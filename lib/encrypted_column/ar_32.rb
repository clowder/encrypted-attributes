module EncryptedColumn
  module AR32
    def encrypted_columns
      @encrypted_columns
    end

    def encrypt(column_name)
      @encrypted_columns = [] unless defined? @encrypted_columns
      @encrypted_columns << column_name
    end

    def define_attribute_methods(*args)
      self.encrypted_columns.each do |column|
        column_name = column.to_s

        define_method(column) do
          aes   = SimpleAES.new(:key => Rails.encrypted_column.key, :iv => Rails.encrypted_column.iv)
          coder = self.class.serialized_attributes[column.to_s]

          value = aes.decrypt(read_attribute(column.to_s))

          coder ? coder.load(value) : value
        end

        define_method("#{ column }=".to_sym) do |value|
          aes            = SimpleAES.new(:key => Rails.encrypted_column.key, :iv => Rails.encrypted_column.iv)
          coder          = self.class.serialized_attributes[column.to_s]

          value          = coder ? coder.dump(value) : value
          encrypted_data = aes.encrypt(value)

          write_attribute(column, encrypted_data)
        end
      end

      super
    end
  end
end
