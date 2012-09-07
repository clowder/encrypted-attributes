require 'spec_helper'

describe EncryptedColumn do
  let(:key) { 'e0cfe841f51d29c0e0a1c51391ca04a6' }
  let(:iv)  { '7b94eae611106dc190b10f40e2d0fde0' }

  let(:encrypto_class) {
    Class.new(ActiveRecord::Base) do
      self.table_name = 'encrypto'
      extend EncryptedColumn
    end
  }

  let(:serialized_encrypto_class) {
    Class.new(ActiveRecord::Base) do
      self.table_name = 'encrypto'
      extend EncryptedColumn

      serialize :description

      encrypt :description
    end
  }

  before(:all) do
    Rails = OpenStruct.new(:encrypted_column => OpenStruct.new(:key => nil, :iv => nil))
    Rails.encrypted_column.key = key
    Rails.encrypted_column.iv = iv
    ActiveRecord::IdentityMap.enabled = false
  end

  it "allows you to specify the columns to be encrypted" do
    encrypto_class.encrypt(:description)
    encrypto_class.encrypted_attributes.should == ['description']
  end

  it "encrypts the data in the database" do
    encrypto_class.encrypt(:description)
    encrypto_class.create(:description => 'this is hidden')

    raw_data = ActiveRecord::Base.connection.execute('SELECT * FROM encrypto').each(:symbolize_keys => true, :as => :hash) { |r| r }
    raw_data[0][:description].should == 'e7bbb4d93712a6edb759ebf947000bdb'
  end

  it "decrypts the data from the database" do
    encrypto_class.encrypt(:description)
    encrypto_class.create(:description => 'this is hidden')

    encrypto_class.last.description.should == 'this is hidden'
  end

  it "works on serialized columns too" do
    serialized_encrypto_class.create(:description => { :foo => 'bar', :baz => 'bat' })
    serialized_encrypto_class.last.description.should == { :foo => 'bar', :baz => 'bat' }
  end
end