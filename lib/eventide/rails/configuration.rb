require 'yaml'

module Eventide::Rails
  module Configuration

    DEFAULTS = {
      'adapter' => 'postgresql',
      'encoding' => 'unicode'
    }.freeze

    def self.load
      YAML.load_file('config/event_store.yml')
        .transform_values { |conf| conf.merge DEFAULTS }
    end

    def self.migration_paths
      File.join ::Eventide::Rails.root_path, 'rails', 'migrations'
    end
  end
end