require 'yaml'

module Eventide::Rails
  module Configuration

    DEFAULTS = {
      'adapter' => 'postgresql',
      'encoding' => 'unicode'
    }.freeze

    CONFIG_KEYS_FOR_TYPE = %i[database host].freeze

    class << self
      def load
        yaml = ERB.new(File.read 'config/event_store.yml').result
        YAML.load(yaml).transform_values { |conf| conf.merge DEFAULTS }
      end

      def current
        load[Rails.env].symbolize_keys
      end

      def setup_type
        return @setup_type if @setup_type
        ar_config = ActiveRecord::Base.configurations[Rails.env].symbolize_keys
        es_config = current

        if db_config(ar_config) == db_config(es_config)
          :homo
        else
          :hetero
        end
      end

      def homo?
        setup_type == :homo
      end

      def hetero?
        setup_type == :hetero
      end

      private

      def db_config(connection_config)
        connection_config.values_at(:database, :adapter, :host)
      end
    end
  end
end