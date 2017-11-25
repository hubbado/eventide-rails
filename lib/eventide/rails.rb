require 'eventide/rails/version'
require 'eventide/rails/configuration'

module Eventide
  module Rails
    def root_path
      File.expand_path(__dir__)
    end
  end
end
