# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "flexserializer/version"

Gem::Specification.new do |spec|
  spec.name          = "flexserializer"
  spec.version       = Flexserializer::VERSION
  spec.authors       = ["woodcrust"]
  spec.email         = ["emptystamp@gmail.com"]

  spec.summary       = 'This is gem flexserializer'
  spec.description   = 'Gem flexserializer for all ruby projects'
  spec.homepage      = 'https://github.com/woodcrust/flexserializer'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*']
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency     'active_model_serializers', '>= 0.10.0'

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
