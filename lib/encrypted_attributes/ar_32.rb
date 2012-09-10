module EncryptedAttributes
  module AR32
    def encrypted_attributes
      @encrypted_attributes
    end

    def encrypt(column_name)
      @encrypted_attributes = [] unless defined? @encrypted_columns
      @encrypted_attributes << column_name.to_s
    end

    def define_attribute_methods(*args)
      self.encrypted_attributes.each do |column|
        define_method(column) do
          coder = self.class.serialized_attributes[column]
          value = EncryptedAttributes.decrypt(read_attribute(column))

          value = coder ? coder.load(value) : value
          value.freeze
        end

        define_method("#{ column }=".to_sym) do |value|
          coder = self.class.serialized_attributes[column]

          value          = coder ? coder.dump(value) : value
          encrypted_data = EncryptedAttributes.encrypt(value)

          write_attribute(column, encrypted_data)
        end
      end

      super
    end
  end
end
