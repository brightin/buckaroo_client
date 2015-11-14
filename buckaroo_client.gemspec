# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'buckaroo_client/version'

Gem::Specification.new do |spec|
  spec.name          = "buckaroo_client"
  spec.version       = BuckarooClient::VERSION
  spec.authors       = ["Floris Huetink"]
  spec.email         = ["floris@brightin.nl"]
  spec.summary       = %q{Ruby support for Buckaroo Payment Engine 3.0}
  spec.homepage      = "https://github.com/brightin/buckaroo_client"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "addressable"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "dotenv", "~> 1.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
