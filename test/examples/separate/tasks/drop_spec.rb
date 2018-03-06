require 'rails_helper'

describe 'rake es:create' do
  let(:task) { Rake::Task['es:drop'] }
  let(:config) { Eventide::Rails::Configuration.load.symbolize_keys }

  def execute!
    task.execute
  end

  before do
    allow(ActiveRecord::Tasks::DatabaseTasks).to receive(:drop)
    allow(ActiveRecord::Tasks::DatabaseTasks).to receive(:env).and_return environment
  end

  context 'when run in test environment' do
    let(:environment) { 'test' }

    it 'drops test es database' do
      execute!

      expect(ActiveRecord::Tasks::DatabaseTasks)
        .to have_received(:drop).once.with config[:test]
    end
  end

  context 'when run in development' do
    let(:environment) { 'development' }

    it 'creates development es database only' do
      execute!

      expect(ActiveRecord::Tasks::DatabaseTasks)
        .to have_received(:drop).once.with config[:development]

      expect(ActiveRecord::Tasks::DatabaseTasks)
        .to have_received(:drop).once.with config[:test]
    end
  end
end