require 'eventide/rails'

tasks = Eventide::Rails::DatabaseTasks

namespace :es do
  desc 'creates event store database'
  task create: :environment do
    tasks.create
    tasks.init
  end

  desc 'creates all the internal objects required for eventide storage'
  task init: :environment do
    tasks.init
  end

  desc 'drops event store database'
  task drop: :environment do
    tasks.drop
  end
end