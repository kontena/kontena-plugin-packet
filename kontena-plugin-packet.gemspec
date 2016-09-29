# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kontena/plugin/packet'

Gem::Specification.new do |spec|
  spec.name          = "kontena-plugin-packet"
  spec.version       = Kontena::Plugin::Packet::VERSION
  spec.authors       = ["Kontena, Inc."]
  spec.email         = ["info@kontena.io"]

  spec.summary       = "Kontena Packet plugin"
  spec.description   = "Packet provision plugin for Kontena"
  spec.homepage      = "https://github.com/kontena/kontena-plugin-packet"
  spec.license       = "Apache-2.0"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'kontena-cli', '~> 0.15.4'
  spec.add_runtime_dependency 'packethost', '>= 0.0.8'
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
