class Register
  include Schema::DataStructure

  attribute :items, default: []

  def add_item(item)
    items << item
  end
end