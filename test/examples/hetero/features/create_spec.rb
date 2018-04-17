require 'spec_helper'

describe 'rake es:create', type: :cli do

  before { system 'rake es:drop' }

  def execute!
    system 'rake es:create'
  end

  context 'when run in test environment' do
    let(:environment) { 'test' }

    it 'creates and migrates test database' do
      expect { execute! }
        .to change { database_exists? :es, :test }.to(true)
    end
  end

  context 'when run in development' do
    let(:environment) { 'development' }

    it 'creates and migrates development and test databases' do
      expect { execute! }
        .to change { database_exists? :es, :development }.to(true)
        .and change { database_exists? :es, :test }.to(true)
    end
  end
end