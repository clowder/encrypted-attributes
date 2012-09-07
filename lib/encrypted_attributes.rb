module EncryptedAttributes
  def self.extended(base)
    ar_version = Gem::Version.new(ActiveRecord::VERSION::STRING)

    if Gem::Requirement.new('~> 2.3.0').satisfied_by? ar_version
      require 'encrypted_attributes/ar_23'
      base.send :extend, AR23
    elsif Gem::Requirement.new('~> 3.2.0').satisfied_by? ar_version
      require 'encrypted_attributes/ar_32'
      base.send :extend, AR32
    else
      fail "Unsupported version of ActiveRecord."
    end
  end
end
