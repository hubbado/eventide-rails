class RegisterProjection
  include EntityProjection

  entity_name :register

  apply Event::ItemAdded do |evt|
    register.add_item evt.item
  end
end