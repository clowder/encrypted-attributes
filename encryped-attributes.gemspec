# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Chris Lowder"]
  gem.email         = ["clowder@gmail.com"]
  gem.description   = %q{AES encrypted attributes with Rails. Behaves similarly to Rails's #serialize and works for versions 2.3.x & 3.2.x.}
  gem.summary       = %q{AES encrypted attributes with Rails.}
  gem.homepage      = "http://github.com/clowder/encrypted-attributes"

  gem.files         = Dir['{lib,spec}/*', 'README.md', 'LICENSE']
  gem.test_files    = Dir['spec/*']
  gem.name          = "encrypted-attributes"
  gem.require_paths = ["lib"]
  gem.version       = '0.0.1'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'pry'
end
