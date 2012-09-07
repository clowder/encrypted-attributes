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
          aes   = SimpleAES.new(:key => Rails.encrypted_column.key, :iv => Rails.encrypted_column.iv)
          coder = self.class.serialized_attributes[column]

          value = aes.decrypt(read_attribute(column))

          coder ? coder.load(value) : value
        end

        define_method("#{ column }=".to_sym) do |value|
          aes            = SimpleAES.new(:key => Rails.encrypted_column.key, :iv => Rails.encrypted_column.iv)
          coder          = self.class.serialized_attributes[column]

          value          = coder ? coder.dump(value) : value
          encrypted_data = aes.encrypt(value)

          write_attribute(column, encrypted_data)
        end
      end

      super
    end
  end
end
