module Utils
  DB_SUFFIXES = {
    development: :dev,
    test: :test
  }.freeze

  def self.db_name(env)
    "<%= name %>_#{DB_SUFFIXES[env.to_sym]}"
  end
end