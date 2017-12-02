require 'eventide/rails'

tasks = Eventide::Rails::DatabaseTasks

namespace :es do
  desc 'creates event store database'
  task :create do
    tasks.create
  end

  desc 'drops event store database'
  task :drop do
    tasks.drop
    # es::Rake.wrap_ar_config do
    #   ActiveRecord::Tasks::DatabaseTasks.drop_current
    # end
  end
end