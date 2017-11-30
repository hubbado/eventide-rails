module Eventide::Rails
  class Message < ActiveRecord::Base
    establish_connection Configuration.load[Rails.env]
  end
end