module EncryptedColumn
  def self.extended(base)
    base.send :include, InstanceMethods
  end

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
        aes = SimpleAES.new(:key => Rails.encrypted_column.key, :iv => Rails.encrypted_column.iv)
        object_from_yaml(aes.decrypt(read_attribute(column.to_s)))
      end
    end

    super
  end

  module InstanceMethods
    def attributes_with_quotes(*args)
      quoted = super

      self.class.encrypted_columns.map(&:to_s).each do |column_name|
        column = column_for_attribute(column_name)
        value  = read_attribute(column_name)

        if self.class.serialized_attributes.has_key?(column_name)
          value = read_attribute(column_name).to_yaml
        end

        aes            = SimpleAES.new(:key => Rails.encrypted_column.key, :iv => Rails.encrypted_column.iv)
        encrypted_data = aes.encrypt(value)

        quoted[column_name] = connection.quote(encrypted_data, column_for_attribute(column_name))
      end

      quoted
    end
  end

end
