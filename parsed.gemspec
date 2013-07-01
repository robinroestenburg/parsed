# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'parsed/version'

Gem::Specification.new do |gem|
  gem.name          = 'parsed'
  gem.version       = Parsed::VERSION
  gem.authors       = ['Robin Roestenburg']
  gem.email         = ['robin@roestenburg.io']
  gem.description   = %q{Parses files into basic Ruby objects. Currently only
                         the JSON format is supported. Future versions are
                         planned to support XML, Haml and TOML.}
  gem.summary       = %q{Write a gem summary}
  gem.homepage      = 'https://github.com/robinroestenburg/parsed'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler', '~> 1.3'
  gem.add_development_dependency 'rake'

  gem.add_runtime_dependency 'activesupport'
end
