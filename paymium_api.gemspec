# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'paymium/api/version'

Gem::Specification.new do |spec|
  spec.name          = "paymium_api"
  spec.version       = Paymium::Api::VERSION
  spec.authors       = ["itkin"]
  spec.email         = ["nicolas.papon@webflows.fr"]
  spec.summary       = %q{Paymium API client}
  spec.description   = %q{Paymium API client}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '~> 2.0'

  spec.add_dependency 'activesupport'
  spec.add_dependency 'oj'
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
end
