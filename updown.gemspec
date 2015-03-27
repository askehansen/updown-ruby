# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'updown/version'

Gem::Specification.new do |spec|
  spec.name          = "updown"
  spec.version       = Updown::VERSION
  spec.authors       = ["Aske Hansen"]
  spec.email         = ["aske@deeco.dk"]
  spec.summary       = %q{Updown.io wrapper}
  spec.description   = %q{A wrapper for the Updown.io API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency 'rest-client'
  spec.add_dependency 'thor'

  spec.add_runtime_dependency 'gem_config'
end
