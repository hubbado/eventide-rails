
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eventide/rails/version'

Gem::Specification.new do |spec|
  spec.name = 'eventide-rails'
  spec.version = Eventide::Rails::VERSION
  spec.authors = ['broisatse']
  spec.email = ['stan@hubbado.com']

  spec.summary = 'Gem integrating eventide with rails application'
  spec.description = 'Set of rake tasks to manage event source database'
  spec.homepage = 'https://github.com/hubbado/eventide-rails'
  spec.license = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0+ is required to protect against public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '~> 5.1'
  spec.add_dependency 'pg'
  spec.add_dependency 'eventide-postgres'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
