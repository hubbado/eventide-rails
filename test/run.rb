#!/usr/bin/env ruby

RAILS_VERSIONS = %w[5.1.4].freeze
TYPES = %i[separate same].freeze

ROOT = File.realpath(File.join(__FILE__, '..')).freeze
VERSIONS_FOLDER = File.join(ROOT, 'versions').freeze

require_relative './run/utils'
require_relative './run/group'

RAILS_VERSIONS.product(TYPES)
  .map { |version, type| Group.new(version, type) }
  .each(&:setup!)
  .each(&:test!)




