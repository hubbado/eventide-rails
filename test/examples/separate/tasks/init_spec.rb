require 'rails_helper'

describe 'rake es:init' do
  let(:task) { Rake::Task['es:init'] }
  let(:config) { Eventide::Rails::Configuration.load.symbolize_keys }

  def execute!
    task.execute
  end

  before do
    allow(Eventide::Rails::DatabaseTasks).to receive(:migrate)
    allow(ActiveRecord::Tasks::DatabaseTasks).to receive(:env).and_return environment
  end

  context 'when run in test environment' do
    let(:environment) { 'test' }

    it 'creates and migrates test database' do
      execute!

      check_database_initialized :test
    end
  end

  context 'when run in development' do
    let(:environment) { 'development' }

    it 'creates and migrates development and test databases' do
      execute!

      check_database_initialized :development
      check_database_initialized :test
    end
  end

  def check_database_initialized(env)
    expect(Eventide::Rails::DatabaseTasks)
        .to have_received(:migrate).with config[env]
  end
end