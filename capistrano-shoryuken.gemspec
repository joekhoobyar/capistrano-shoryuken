# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "capistrano/shoryuken/version"

Gem::Specification.new do |spec|
  spec.name        = "capistrano-shoryuken"
  spec.version     = Capistrano::Shoryuken::VERSION
  spec.authors     = ["Joe Khoobyar"]
  spec.email       = ["joe@khoobyar.name"]
  spec.homepage    = "http://github.com/joekhoobyar/capistrano-shoryuken"
  spec.summary     = 'Shoryuken integration for Capistrano'
  spec.description = 'Shoryuken integration for Capistrano'
  
  spec.license = "LGPL-3.0"
  spec.files = `git ls-files -z`.split("\x0")
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.required_ruby_version = '>= 1.9.3'
  
  spec.add_dependency 'capistrano'
end
