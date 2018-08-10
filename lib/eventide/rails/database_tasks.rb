module Eventide::Rails
  module DatabaseTasks
    FUNCTIONS = %w[
      hash-64
      category
      stream-version
      write-message
      get-stream-messages
      get-category-messages
      get-last-message
    ].freeze

    class << self
      ARTasks = ActiveRecord::Tasks::DatabaseTasks

      def create
        return if Configuration.homo?
        wrap_ar_config do
          ARTasks.create_current
        end
      end

      def init
        wrap_ar_config do
          ARTasks.send(:each_current_configuration, ARTasks.env) do |config|
            init_database config
          end
        end
      end

      def drop
        return if Configuration.homo?
        wrap_ar_config do
          ActiveRecord::Tasks::DatabaseTasks.drop_current
        end
      end

      def check
        wrap_ar_config do
          ARTasks.send(:each_current_configuration, ARTasks.env) do |config|
            check_status config
          end
        end
      end

      def update
        wrap_ar_config do
          ARTasks.send(:each_current_configuration, ARTasks.env) do |config|
            update_database config
          end
        end
      end

      private

      def wrap_ar_config
        config = ActiveRecord::Base.configurations
        ActiveRecord::Base.configurations = Configuration.load
        yield
      ensure
        ActiveRecord::Base.configurations = config
      end

      def init_database(config)
        connection = connection_for(config) do
          $stderr.puts "Eventide cannot be initialized for #{config['database']}: database not created"
          return
        end

        if ready?(connection)
          puts "Eventide for '#{config['database']}' already initialized"
          return
        end

        if messages_table_present?(connection)
          puts "#{config['database']}: cannot initialize, table messages already exists"
          puts "Did you mean `rake es:update`?"
        end

        execute_script script_path('extensions.sql'), connection
        install_functions(connection)
        execute_directory('table', connection)
        execute_directory('indexes', connection, split_commands: true)
        execute_directory('views', connection)
      end

      def update_database(config)
        connection = connection_for(config) do
          $stderr.puts "Eventide cannot be updated for #{config['database']}: database not created"
          return
        end

        install_functions(connection)
        execute_directory('indexes', connection, split_commands: true)
        execute_directory('views', connection)

        update_position_types(connection)
      end

      def update_position_types(connection)
        connection.execute <<~SQL
          UPDATE messages
            SET type = 'Recorded'
            WHERE type = 'Updated'
              AND (stream_name LIKE '%+position'
                OR stream_name LIKE '%:position'
                OR stream_name LIKE '%:position-%')
        SQL
      end

      def execute_script(path, connection, split_commands: false)
        sql = File.read(path)
        commands = split_commands ? sql.split(/;$/) : [sql]
        commands.each do |cmd|
          connection.execute cmd
        end
      end

      def execute_directory(dir, connection, split_commands: false)
        Dir[script_path dir, '*.sql'].each { |path| execute_script path, connection, split_commands: split_commands }
      end

      def check_status(config)
        connection = connection_for(config) do
          $stderr.puts "Database #{config['database']} does not exist"
          return
        end

        if ready?(connection)
          puts "Eventide for '#{config['database']}' is fully initialized"
          return
        end

        if messages_table_present?(connection)
          puts "#{config['database']} is partially configured. Run `rake es:update` to install missing functions and views"
          return
        end

        puts "#{config['database']} is not initialized for event store"
      end

      def ready?(connection)
        return false unless messages_table_present?(connection)
        select_body = FUNCTIONS
          .map { |fn| "'#{fn.tr('-', '_')}'::regproc" }
          .join(', ')

        connection.execute "SELECT #{select_body}"
        true
      rescue ActiveRecord::StatementInvalid
        false
      end

      def messages_table_present?(connection)
        connection.execute 'SELECT 1 as result from "messages"'
        true
      rescue ActiveRecord::StatementInvalid
        false
      end

      def install_functions(connection)
        execute_directory('types', connection)

        FUNCTIONS.each do |fn|
          execute_script script_path("functions/#{fn}.sql"), connection
        end
      end

      def script_root
        @script_root ||= File.join(
          Gem::Specification.find_by_name('evt-message_store-postgres-database').gem_dir,
          'database'
        )
      end

      def script_path(*path)
        File.join script_root, *path
      end

      def connection_for(config)
        ActiveRecord::Base.establish_connection(config).connection
      rescue ActiveRecord::NoDatabaseError
        yield
      end
    end
  end
end