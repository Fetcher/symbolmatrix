# -*- encoding: utf-8 -*-
require File.expand_path('../lib/symbolmatrix/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Xavier Via"]
  gem.email         = ["xavier.via.canel@gmail.com"]
  gem.description   = %q{Very useful for configuration files, SymbolMatrix is a hash-like multidimentional Symbol-only class with ability to discover and load YAML data}
  gem.summary       = %q{Very useful for configuration files, SymbolMatrix is a hash-like multidimentional Symbol-only class with ability to discover and load YAML data}
  gem.homepage      = "http://github.com/fetcher/symbolmatrix"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "fast"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "symbolmatrix"
  gem.require_paths = ["lib"]
  gem.version       = Symbolmatrix::VERSION
end
