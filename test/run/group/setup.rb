require 'yaml'
require 'erb'
require 'ostruct'
require 'fileutils'
require 'bundler'

class Group::Setup
  def self.configuration
    @config ||= YAML.load_file(File.join(ROOT, 'config.yml'))
  end

  def self.configured?
    File.file?(File.join(ROOT, 'config.yml'))
  end

  def self.call(group)
    new(group).()
  end

  def initialize(group)
    @group = group
  end

  def call
    return puts "#{desc}: already prepared" if already_setup?

    puts "#{desc}: preparing"

    Bundler.with_clean_env do
      install_railtie
      create_rails_app
      copy_templates(type)
      copy_templates(:common)
      install_gems
      copy_examples
    end
  end

  private

  include Utils

  delegate :version, :type, :directory, :name, :desc, to: :@group

  def already_setup?
    File.directory?(directory)
  end

  def install_railtie
    return if railtie_installed?
    `gem install railties -v #{version} &> /dev/null`
  end

  def railtie_installed?
    return false unless (versions = `gem list | grep railtie`.strip) != ''
    versions.match(/\((.*)\)/)[1].split(', ').include?(version)
  end

  def create_rails_app
    Dir.mkdir(VERSIONS_FOLDER) unless File.directory?(VERSIONS_FOLDER)
    Dir.chdir(VERSIONS_FOLDER)
    `rails _#{version}_ new #{name} #{options_for_rails_create} &> /dev/null`
    Dir.chdir(directory)
  end

  def options_for_rails_create
    opts = '-T'
    opts += ' -d postgresql' if type == :same
    opts
  end

  def copy_templates(type)
    Dir.glob(File.join(templates_directory(type), '**', '*')).each do |file|
      next unless File.file?(file)
      content = File.read(file)
      result = ERB.new(content).result(erb_binding)
      relative = file.gsub(templates_directory(type), '')
      target = File.join(directory, relative)
      dir = File.dirname(target)
      FileUtils.mkdir_p(dir) unless File.directory?(dir)
      File.open(File.join(directory, relative), 'w+') do |file|
        file.write result
      end
    end
  end

  def templates_directory(type)
    File.join(ROOT, 'templates', type.to_s)
  end

  def erb_binding
    OpenStruct.new(config).instance_eval { binding }
  end

  def config
    self.class.configuration.merge(name: name.tr('.', '_'))
  end

  def install_gems
    `echo "gem 'rspec-rails', group: :test" >> #{File.join(directory, 'Gemfile')}`
    `echo "gem 'eventide-rails', path: '../../..'" >> #{File.join(directory, 'Gemfile')}`
    `echo "gem 'eventide-postgres'" >> #{File.join(directory, 'Gemfile')}`
    `bundle install`
  end

  def copy_examples
    ['common', type.to_s].each do |dir|
      `cp -r #{File.join(ROOT, 'examples', dir)} #{File.join(directory, 'spec')}`
    end
  end
end
