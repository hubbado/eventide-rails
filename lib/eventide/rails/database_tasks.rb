module Eventide::Rails
  module DatabaseTasks
    class << self

      ARTasks = ActiveRecord::Tasks::DatabaseTasks

      def create
        wrap_ar_config do
          ARTasks.create_current
          ARTasks.send(:each_current_configuration, ARTasks.env) do |config|
            migrate config
          end
        end
      end

      def drop
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
        connection = ActiveRecord::Base.establish_connection(config).connection
        execute_script script_path('extensions.sql'), connection
        execute_directory('functions', connection)
        execute_directory('table', connection)
        execute_directory('indexes', connection)
      end

      def execute_script(path, connection)
        connection.execute File.read(path)
      end

      def execute_directory(dir, connection)
        Dir[script_path dir, '*.sql'].each { |path| execute_script path, connection }
      end

      def script_root
        @script_root ||= File.join(
          Gem::Specification.find_by_name('evt-message_store-postgres').gem_dir,
          'database'
        )
      end

      def script_path(*path)
        File.join script_root, *path
      end
    end
  end
end