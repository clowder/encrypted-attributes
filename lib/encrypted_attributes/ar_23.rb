module EncryptedAttributes
  module AR23
    def self.extended(base)
      base.send :include, InstanceMethods
    end

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
          object_from_yaml(EncryptedAttributes.encrypter.decrypt(read_attribute(column)))
        end
      end

      super
    end

    module InstanceMethods
      def attributes_with_quotes(*args)
        quoted = super

        self.class.encrypted_attributes.each do |column_name|
          column = column_for_attribute(column_name)
          value  = read_attribute(column_name)

          if self.class.serialized_attributes.has_key?(column_name)
            value = read_attribute(column_name).to_yaml
          end

          encrypted_data = EncryptedAttributes.encrypter.encrypt(value)

          quoted[column_name] = connection.quote(encrypted_data, column_for_attribute(column_name))
        end

        quoted
      end
    end
  end
end
