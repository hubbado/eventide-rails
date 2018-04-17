require 'spec_helper'

describe 'rake es:create', type: :cli do

  before { system 'rake db:drop' }

  it 'is NO-OP' do
    expect { system 'rake es:create' }
      .not_to(change {
        [
          database_exists?(:ar, :development),
          database_exists?(:ar, :test),
          database_exists?(:es, :development),
          database_exists?(:es, :development)
        ]
      })
  end

  describe 'enahncing db:create' do
    it 'created and initializes the database and eventide' do
      system 'rake db:create'

      expect(database_exists?(:ar, :development)).to be true
      expect(es_database_ready?(:development)).to be true

      expect(database_exists?(:ar, :test)).to be true
      expect(es_database_ready?(:test)).to be true

    end
  end
end