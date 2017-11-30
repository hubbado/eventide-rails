require 'yaml'

module Eventide::Rails
  module Configuration

    DEFAULTS = {
      adapter: :postgresql,
      encoding: :unicode
    }.freeze

    def self.load
      configs = YAML.load_file('config/event_store.yml')
      configs.transform_values! do |configuration|
        configuration.merge DEFAULTS
      end
    end

    def self.migration_paths
      File.join ::Eventide::Rails.root_path, 'migrations'
    end
  end
end