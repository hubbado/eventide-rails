module Support
  module Database

    def self.included(mod)
      mod.use_transactional_tests = false
    end

    def ensure_no_es_database
      return unless es_database_exists?
      drop_database
    end

    def es_database_exists?
      execute es_config, "psql -lqt | grep -qw #{es_config[:database]}"
    end

    private

    def drop_database
      execute es_config, "dropdb #{es_config[:database]}"
    end

    def es_config
      @es_config ||= Eventide::Rails::Configuration.load.deep_symbolize_keys[:test]
    end

    def command_env_for(config)
      env = {}
      env[:pguser] = config[:username] if config[:username]
      env[:pgpassword] = config[:password] if config[:password]
      env[:pghost] = config[:host] if config[:host]
      env
        .transform_keys { |k| k.to_s.upcase }
        .map { |k, v| "#{k}=#{v}" }
        .join(' ')
    end

    def execute(config, cmd)
      cmd = "#{command_env_for(config)} #{cmd}"
      system cmd
    end
  end
end