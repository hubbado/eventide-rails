require 'eventide/rails'

module Eventide::Rails
  module Rake
    def self.wrap_ar_config
      config = ActiveRecord::Base.configurations
      mp = ActiveRecord::Migrator.migrations_paths
      verbose = ActiveRecord::Migration.verbose

      ActiveRecord::Base.configurations = Configuration.load
      ActiveRecord::Migrator.migrations_paths = Configuration.migration_paths
      ActiveRecord::Migration.verbose = false

      yield

    ensure
      ActiveRecord::Base.configurations = config
      ActiveRecord::Migrator.migrations_paths = mp
      ActiveRecord::Migration.verbose = verbose
    end
  end
end

es = Eventide::Rails

namespace :es do
  desc 'creates event store database'
  task :create do
    es::Rake.wrap_ar_config do
      ActiveRecord::Tasks::DatabaseTasks.create_current
      ActiveRecord::Migrator.migrate(es::Configuration.migration_paths)
    end
  end

  desc 'drops event store database'
  task :drop do
    es::Rake.wrap_ar_config do
      ActiveRecord::Tasks::DatabaseTasks.drop_current
    end
  end
end