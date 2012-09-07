module EncryptedAttributes
  module AR23
    def encrypted_attributes
      @encrypted_attributes
    end

    def encrypt(column_name)
      @encrypted_attributes = [] unless defined? @encrypted_columns
      @encrypted_attributes << column_name.to_s
    end

    def define_attribute_methods(*args)
      self.encrypted_attributes.each do |column|
        define_read_method("read_encrypted_#{column}", column, columns_hash[column])
        evaluate_attribute_method "write_encrypted_#{column}=", "def write_encrypted_#{column}=(new_value);write_attribute('#{column}', new_value);end"

        define_method(column) do
          encrypted_value = self.send("read_encrypted_#{column}")
          object_from_yaml(EncryptedAttributes.encrypter.decrypt(encrypted_value)).freeze
        end

        define_method("#{column}=") do |new_value|
          if self.class.serialized_attributes.has_key?(column)
            new_value = new_value.to_yaml
          end

          encrypted_value = EncryptedAttributes.encrypter.encrypt(new_value)
          self.send("write_encrypted_#{column}=", encrypted_value)
        end
      end

      super
    end
  end
end
