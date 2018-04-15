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
    end
  end
end