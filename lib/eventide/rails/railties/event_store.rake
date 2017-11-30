require 'eventide/rails'

ES = Eventide::Rails

namespace :es do
  task :load_config do
    ActiveRecord::Base.configurations = ES::Configuration.load
    ActiveRecord::Base.migrations_paths = ES::Configuration.migration_paths
  end

  desc 'creates event store database'
  task create: :load_config do
    ActiveRecord::Tasks::DatabaseTasks.create_all
  end
end