class Command::AddItem
  include Messaging::Message

  attribute :register_uuid
  attribute :item
end