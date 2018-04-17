require 'spec_helper'

describe 'rake es:init', type: :cli do
  before do
    system 'rake db:drop'
    create_empty_db(:es, :development)
    create_empty_db(:es, :test)

    expect(database_exists?(:es, :development)).to be true
    expect(database_exists?(:es, :test)).to be true
  end

  def execute!
    system 'rake es:init'
  end

  context 'when run in test environment' do
    let(:environment) { 'test' }

    it 'creates and migrates test database' do
      expect { execute! }
        .to change { es_database_ready?(:test) }.to(true)
    end
  end

  context 'when run in development' do
    let(:environment) { 'development' }

    it 'creates and migrates development and test databases' do
      expect { execute! }
        .to change { es_database_ready?(:test) }.to(true)
        .and change { es_database_ready?(:development) }.to(true)
    end
  end
end