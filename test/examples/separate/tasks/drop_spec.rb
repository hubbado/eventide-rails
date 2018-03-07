require 'rails_helper'

describe 'rake es:drop' do
  let(:config) { Eventide::Rails::Configuration.load.symbolize_keys }

  def execute!
    `RAILS_ENV=#{environment} rake db:drop`
  end

  after(:each) do
    `RAILS_ENV=#{environment} rake db:create`
  end

  context 'when run in test environment' do
    let(:environment) { 'test' }

    it 'drops test es database' do
      expect { execute! }
        .to change { database_exists?[:test] }.from(true).to(false)
    end
  end

  # context 'when run in development' do
  #   let(:environment) { 'development' }
  #
  #   it 'creates development es database only' do
  #     execute!
  #
  #     expect(ActiveRecord::Tasks::DatabaseTasks)
  #       .to have_received(:drop).once.with config[:development]
  #
  #     expect(ActiveRecord::Tasks::DatabaseTasks)
  #       .to have_received(:drop).once.with config[:test]
  #   end
  # end

  def database_exists?(env)
    ActiveRecord::Base.establish_connection(config[env.to_sym])
    true
  rescue ActiveRecord::NoDatabaseError
    false
  end
end