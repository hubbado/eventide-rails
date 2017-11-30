module Eventide::Rails
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load File.expand_path(File.join(__dir__, 'railties', 'event_store.rake'))
    end
  end
end