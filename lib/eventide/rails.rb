module Eventide
  module Rails
    autoload :Message, 'eventide/rails/message'

    def self.root_path
      File.expand_path(__dir__)
    end
  end
end

require 'eventide/rails/version'
require 'eventide/rails/configuration'

if defined?(::Rails)
  require 'eventide/rails/railtie'
end
