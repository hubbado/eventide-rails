require 'spec_helper'

describe 'schema.rb', type: :cli do

  before { system 'rake db:create db:migrate' }

  it 'does not include eventide messages table' do
    schema_file = File.read('db/schema.rb')
    expect(schema_file).not_to include('create_table "messages"')
  end
end