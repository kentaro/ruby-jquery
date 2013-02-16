# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jquery/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby-jquery"
  spec.version       = JQuery::VERSION
  spec.authors       = ["Kentaro Kuribayashi"]
  spec.email         = ["kentarok@gmail.com"]
  spec.description   = %q{jQuery Expression Generator}
  spec.summary       = %q{jQuery Expression Generator}
  spec.homepage      = "http://github.com/kentaro/ruby-jquery"
  spec.license       = "MIT"

  spec.required_ruby_version = '>= 1.9.2'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 2.12"
  spec.add_development_dependency "rake"
end
