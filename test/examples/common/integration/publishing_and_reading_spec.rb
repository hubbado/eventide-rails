require 'rails_helper'

describe 'Database connection' do

  let(:register_uuid) { SecureRandom.uuid }
  let(:item) { rand(1..100) }
  let(:store) { Store.new }

  it 'allows basic operations' do
    entity = store.fetch(register_uuid)

    expect(entity.items).to be_empty

    cmd = Command::AddItem.copy(
      register_uuid: register_uuid,
      item: item
    )
    RegisterHandler.(cmd)

    entity = store.fetch(register_uuid)
    expect(entity.items).to include item
  end
end