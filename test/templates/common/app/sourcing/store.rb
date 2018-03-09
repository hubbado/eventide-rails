class Store
  include EntityStore

  category :registry
  entity Register
  projection RegisterProjection

  reader MessageStore::Postgres::Read
end