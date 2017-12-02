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
require 'eventide/rails/setting_patch'
require 'eventide/rails/database_tasks'

require 'eventide/rails/railtie' if defined?(::Rails)
