require 'yaml'
require 'active_record'
require 'eventide/rails'

module CliGroup
  ROOT = File.expand_path File.join(__FILE__, '..', '..', '..')

  def system(env = {}, command, **opts)
    opts[:out] = opts[:err] = File::NULL
    super(env, command, **opts)
  end

  def assert_command(env = {}, command, result)
    failure_message = "Expected command #{command} to #{result ? 'run successfully' : 'fail'}, but it didn't."
    expect(system(env, command)).to eq(result, failure_message)
  end

  def database_exists?(type, env)
    db = db_config(type, env)

    pg_system('psql -lq', "grep -w #{db['database']}", db: db)
  end

  def create_empty_db(type, env)
    db = db_config(type, env)

    pg_system "createdb #{db['database']}", db: db
  end

  def es_database_ready?(env)
    db = es_config(env)
    pg_system %(psql #{db['database']} -c "SELECT 'write_message'::regproc, 'category'::regproc"), db: db
  end

  private

  def ar_config(env)
    @ar_config ||= begin
      config_file = File.join(ROOT, 'config/database.yml')
      parse_db_configs YAML.load_file(config_file)
    end
    @ar_config[env.to_s]
  end

  def es_config(env)
    @es_config ||= Eventide::Rails::Configuration.load
    @es_config[env.to_s]
  end

  def parse_db_configs(configs)
    ActiveRecord::ConnectionHandling::MergeAndResolveDefaultUrlConfig.new(configs).resolve
  end


  def db_config(type, env)
    raise "Unknown type: #{type}" unless %w[ar es].include? type.to_s
    send("#{type}_config", env)
  end

  def pg_system(*cmds, db:)
    cmd = cmds.shift
    cmd += " -h #{db['host']}" if db['host']
    cmd += " -U #{db['username']}" if db['username']

    env = db['password'] ? { 'PGPASSWORD' => db['password'] } : {}
    cmd = [cmd, *cmds].join(' | ')
    system env, cmd
  end

  RSpec.configure do |rspec|
    rspec.include self, type: :cli
  end
end