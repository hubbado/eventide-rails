#!/usr/bin/env ruby

RAILS_VERSIONS = %w[5.1.4].freeze

ROOT = File.realpath(File.join(__FILE__, '..')).freeze
VERSIONS_FOLDER = File.join(ROOT, 'versions').freeze

require_relative './run/setup'

Setup.run!

