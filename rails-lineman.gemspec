# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_lineman/version'

Gem::Specification.new do |spec|
  spec.name          = "rails-lineman"
  spec.version       = RailsLineman::VERSION
  spec.authors       = ["Justin Searls", "Diego F. Gomez"]
  spec.email         = ["searls@gmail.com", "diego.f.gomez.pardo@gmail.com"]
  spec.description   = %q{Helps Rails apps integrate a Lineman into their build by copy the frontend dist files into the public folder.}
  spec.summary       = %q{Helps Rails apps integrate a Lineman into their build by copy the frontend dist files into the public folder.}
  spec.homepage      = "https://github.com/degzcs/rails-lineman"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rake"
  spec.add_development_dependency "bundler", "~> 1.3"
end
