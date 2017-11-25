# require 'yaml'
#
# module Eventide::Rails
#   module Configuration
#
#     DEFAULTS = {
#       adapter: :postgresql,
#       encoding: :unicode
#     }.freeze
#
#     def load
#       configs = YAML.load_file('config/event_store.yml')
#       configs.transfrom_values! do |configuration|
#         configuration.merge DEFAULTS
#       end
#     end
#
#     def migration_paths
#       [::Eventide::Rails.root, migrations].join(File::SEPARATOR)
#     end
#   end
# end