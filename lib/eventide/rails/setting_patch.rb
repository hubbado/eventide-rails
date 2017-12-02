require 'message_store/postgres'

module MessageStore
  module Postgres
    class Settings < ::Settings
      class << self
        def data_source
          config = Eventide::Rails::Configuration.load[Rails.env]
          config = ActiveRecord::ConnectionHandling::MergeAndResolveDefaultUrlConfig
            .new(config: config)
            .resolve[:config]
          normalize(config)
        end

        private

        def normalize(config)
          config['dbname'] = config.delete('database')
          config['user'] = config.delete('username')
          config
        end
      end
    end
  end
end
