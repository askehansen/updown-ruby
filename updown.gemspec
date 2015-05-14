# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'updown/version'

Gem::Specification.new do |spec|
  spec.name          = "updown"
  spec.version       = Updown::VERSION
  spec.authors       = ["Aske Hansen", "Adrien Jarthon"]
  spec.email         = ["aske@deeco.dk", "me@adrienjarthon.com"]
  spec.summary       = %q{updown.io API wrapper}
  spec.description   = %q{A wrapper for the updown.io API}
  spec.homepage      = "https://github.com/askehansen/updown-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency 'rest-client'
  spec.add_dependency 'thor'
  spec.add_dependency 'gem_config'
  spec.add_dependency 'colorize'
end
