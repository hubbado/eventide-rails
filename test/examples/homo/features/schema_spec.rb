require 'spec_helper'

describe 'schema.rb', type: :cli do

  before { system 'rake db:create db:migrate' }

  it 'does not include eventide messages table' do
    schema_file = File.read('db/schema.rb')
    expect(schema_file).not_to include('create_table "messages"')
  end

  describe 'loading' do
    before do
      system 'rake db:schema:drop db:drop'
      create_empty_db(:ar, :development)
    end

    it 'initializes eventide system' do
      system 'db:schema:load'
      expect(es_database_ready?(:development)).to be true
    end
  end

end