module Eventide::Rails
  module DatabaseTasks
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
            migrate config
          end
        end
      end

      def drop
        return if Configuration.homo?
        wrap_ar_config do
          ActiveRecord::Tasks::DatabaseTasks.drop_current
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

      def migrate(config)
        begin
          connection = ActiveRecord::Base.establish_connection(config).connection
        rescue ActiveRecord::NoDatabaseError
          $stderr.puts "Eventide cannot be initialized for #{config['database']}: database not created"
          return
        end
        if migrated?(connection)
          puts "Eventide for '#{config['database']}' already initialized"
          return
        end
        execute_script script_path('extensions.sql'), connection
        execute_directory('table', connection)
        execute_directory('types', connection)
        %w[
          hash-64
          category
          stream-version
          write-message
          get-stream-messages
          get-category-messages
          get-last-message
        ].each do |fn|
          execute_script script_path("functions/#{fn}.sql"), connection
        end
        execute_directory('indexes', connection)
        execute_directory('views', connection)
      end

      def execute_script(path, connection)
        connection.execute File.read(path)
      end

      def execute_directory(dir, connection)
        Dir[script_path dir, '*.sql'].each { |path| execute_script path, connection }
      end

      def migrated?(connection)
        connection.execute "SELECT 'write_message'::regproc, 'category'::regproc"
        true
      rescue ActiveRecord::StatementInvalid
        false
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
    end
  end
end