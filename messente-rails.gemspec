# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'messente-rails/version'

Gem::Specification.new do |spec|
  spec.name          = 'messente-rails'
  spec.version       = Messente::Rails::VERSION
  spec.authors       = ['Vjatseslav Gedrovits']
  spec.email         = ['vjatseslav.gedrovits@gmail.com']
  spec.summary       = %q{Messente.com API wrapper for Rails}
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/Gedrovits/messente-rails'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  # spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  # spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
end
