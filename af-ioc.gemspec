# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'af/ioc/version'

Gem::Specification.new do |spec|
  spec.name          = "af-ioc"
  spec.version       = Af::Ioc::VERSION
  spec.authors       = ["Dmitry Boltrushko"]
  spec.email         = ["bdimonik@gmail.com"]
  spec.summary       = %q{Lightweight IoC/DI solution for Ruby.}
  spec.description   = %q{Lightweight IoC/DI solution for Ruby.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"

  spec.add_dependency "activesupport", "~> 4.0"
end
