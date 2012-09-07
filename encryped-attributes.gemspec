# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Chris Lowder"]
  gem.email         = ["clowder@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = Dir['{lib,spec}/*']
  gem.test_files    = Dir['spec/*']
  gem.name          = "encrypted-attributes"
  gem.require_paths = ["lib"]
  gem.version       = '0.0.1'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'pry'
end
