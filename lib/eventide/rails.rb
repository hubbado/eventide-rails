module Eventide
  module Rails
    def self.root_path
      File.expand_path(__dir__)
    end
  end
end

require 'eventide/rails/version'
require 'eventide/rails/configuration'
require 'eventide/rails/railtie' if defined?(::Rails)
