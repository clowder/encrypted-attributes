module EncryptedAttributes
  class Railtie < Rails::Railtie
    config.encrypted_attributes = ActiveSupport::OrderedOptions.new
    config.encrypted_attributes.key = nil
    config.encrypted_attributes.iv  = nil

    initializer :encrypted_attributes do |app|
      EncryptedAttributes.setup(:key => app.config.encrypted_attributes.key, :iv => app.config.encrypted_attributes.iv)
    end
  end
end
