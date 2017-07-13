# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'firebase/auth/version'

Gem::Specification.new do |spec|
  spec.name          = "firebase-auth"
  spec.version       = Firebase::Auth::VERSION
  spec.authors       = ["Huy Hùng"]
  spec.email         = ["huyhung1994@gmail.com"]

  spec.summary       = "Firebase Authentication wrapper for Ruby"
  spec.homepage      = "https://github.com/hungdh0x5e/firebase-auth"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_runtime_dependency "rest-client", "~> 2.0"
end
