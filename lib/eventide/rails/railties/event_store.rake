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

  desc 'checks the state of event store'
  task check: :environment do
    tasks.check
  end

  desc 'reinstalls event store functions and views'
  task update: :environment do
    tasks.update
  end
end