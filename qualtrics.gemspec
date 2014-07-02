# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qualtrics/version'

Gem::Specification.new do |spec|
  spec.name          = "qualtrics"
  spec.version       = Qualtrics::VERSION
  spec.authors       = ["Kevin Sun", "Ben Calegari"]
  spec.email         = ["sunkev@brandeis.edu", "bencalegari@gmail.com"]
  spec.summary       = %q{Client for Qualtrics API}
  spec.description   = %q{Client for Qualtrics API with Faraday}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency 'dotenv'
end
