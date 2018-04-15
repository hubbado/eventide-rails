module Eventide::Rails
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load File.expand_path(File.join(__dir__, 'railties', 'event_store.rake'))

      ::Rake::Task['db:create'].enhance do
        ::Rake::Task['es:create'].invoke
      end

      ::Rake::Task['db:drop'].enhance do
        ::Rake::Task['es:drop'].invoke
      end

      ::Rake::Task['db:schema:load'].enhance do
        ::Rake::Task['es:init'].invoke
      end
    end

    initializer 'eventide:rails:schema' do
      if Configuration.homo?
        ActiveRecord::SchemaDumper.ignore_tables << 'messages'
      end
    end
  end
end

