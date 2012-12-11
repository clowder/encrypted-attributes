$:.unshift File.dirname(__FILE__)

require 'simple_aes'
require 'encrypted_attributes'

if defined?(Rails)
  if Gem::Requirement.new('~> 3.0.0').satisfied_by? Gem::Version.new(Rails.version)
    require 'encrypted_attributes/railtie'
  end
end
