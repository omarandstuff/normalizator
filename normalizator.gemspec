lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'normalizator/version'

Gem::Specification.new do |spec|
  spec.name = 'normalizator'
  spec.version = Normalizator.gem_version
  spec.summary = 'Normalizator normalize your unnormalized data'
  spec.authors = ['David De Anda']
  spec.email = 'timrudat@gmail.com'
  spec.description = ''
  spec.homepage = 'https://github.com/omarandstuff/normalizator'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.1'

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|gemfiles|coverage|bin|media)/}) }
  spec.executables = []
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w[lib]

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'simplecov-json'
end
