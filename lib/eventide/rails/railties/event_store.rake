require 'eventide/rails'

ES = Eventide::Rails

namespace :es do
  task :load_config do
    ActiveRecord::Tasks::DatabaseTasks.database_configurations = ES::Configuration.load
    ActiveRecord::Tasks::DatabaseTasks.migrations_paths = ES::Configuration.migration_paths
  end

  desc 'creates event store database'
  task create: :load_config do
  end
end