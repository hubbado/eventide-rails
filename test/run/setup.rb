require 'yaml'
require 'erb'
require 'ostruct'
require 'byebug'
require 'bundler'

class Setup
  def self.run!
    unless configured?
      puts 'test/config.yml file not found!'
      return
    end

    RAILS_VERSIONS.each do |version|
      %i[separate same].each do |type|
        setup(version, type)
      end
    end
  end

  def self.setup(version, type)
    new(version, type).run!
  end

  def self.configuration
    @config ||= YAML.load_file(File.join(ROOT, 'config.yml'))
  end

  def self.configured?
    File.file?(File.join(ROOT, 'config.yml'))
  end

  def initialize(version, type)
    @version = version
    @type = type
  end

  def run!
    if already_setup?
      puts "#{description}: already prepared"
      return
    end

    puts "#{description}: preparing"

    install_railtie
    create_rails_app
    copy_templates
    install_gems
    copy_examples
  end

  private

  attr_reader :version, :type

  def description
    "rails #{version}, #{type} databases"
  end

  def already_setup?
    File.directory?(directory)
  end

  def directory_name
    @directory_name ||= [type, version].join('_')
  end

  def directory
    @directory ||= File.join(VERSIONS_FOLDER, directory_name)
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
    `rails _#{version}_ new #{directory_name} #{options_for_rails_create} &> /dev/null`
    Dir.chdir(directory)
  end

  def options_for_rails_create
    opts = '-T'
    opts += ' -d postgresql' if type == :same
    opts
  end

  def copy_templates
    Dir.glob(File.join(templates_directory, '**', '*')).each do |file|
      next unless File.file?(file)
      content = File.read(file)
      result = ERB.new(content).result(erb_binding)
      relative = file.gsub(templates_directory, '')
      File.open(File.join(directory, relative), 'w+') do |file|
        file.write result
      end
    end
  end

  def templates_directory
    File.join(ROOT, 'templates', type.to_s)
  end

  def erb_binding
    OpenStruct.new(config).instance_eval { binding }
  end

  def config
    self.class.configuration.merge(name: directory_name.tr('.', '_'))
  end

  def install_gems
    `echo "gem 'rspec-rails', group: :test" >> #{File.join(directory, 'Gemfile')}`
    `echo "gem 'eventide-rails', path: '../../..'" >> #{File.join(directory, 'Gemfile')}`
    `echo "gem '', path: '../../..'" >> #{File.join(directory, 'Gemfile')}`
    Bundler.with_clean_env { `bundle install` }
  end

  def copy_examples
    `cp -r #{File.join(ROOT, 'examples', type.to_s)} #{File.join(directory, 'spec')}`
  end
end
