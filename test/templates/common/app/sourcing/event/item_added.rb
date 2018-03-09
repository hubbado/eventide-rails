class Event::ItemAdded
  include Messaging::Message

  attribute :register_uuid
  attribute :item
end