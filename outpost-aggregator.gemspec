# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'outpost/aggregator/version'

Gem::Specification.new do |spec|
  spec.name          = "outpost-aggregator"
  spec.version       = Outpost::Aggregator::VERSION
  spec.authors       = ["Bryan Ricker"]
  spec.email         = ["bricker88@gmail.com"]
  spec.description   = %q{Content aggregator for Outpost}
  spec.summary       = %q{A simple UI to help aggregate content using an API.}
  spec.homepage      = "https://github.com/SCPR/outpost-aggregator"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
