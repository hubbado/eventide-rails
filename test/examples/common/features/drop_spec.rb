require 'spec_helper'

describe 'rake es:drop', type: :cli do

  before { system('rake db:create') }

  describe 'extension of db:drop' do
    def execute!
      system('rake db:drop')
    end

    context 'when run in test environment' do
      let(:environment) { 'test' }

      it 'drops test database' do

        expect { execute! }
          .to change { database_exists?(:es, :test) }.to(false)
      end
    end

    context 'when run in development' do
      let(:environment) { 'development' }

      it 'drops test database' do
        expect { execute! }
          .to change { database_exists?(:es, :test) }.to(false)
          .and change { database_exists?(:es, :development) }.to(false)
      end
    end
  end

  describe 'when executed alone' do
    def execute!
      system('rake es:drop')
    end

    context 'when run in test environment' do
      let(:environment) { 'test' }

      it 'drops test database' do

        expect { execute! }
          .to change { database_exists?(:es, :test) }.to(false)
      end
    end

    context 'when run in development' do
      let(:environment) { 'development' }

      it 'drops test and development databases' do
        expect { execute! }
          .to change { database_exists?(:es, :test) }.to(false)
          .and change { database_exists?(:es, :development) }.to(false)
      end
    end

  end
end