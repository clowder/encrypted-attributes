$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'bundler'
require 'ostruct'
Bundler.require(:default, :test)

ActiveRecord::Base.establish_connection({
  :adapter  => 'mysql2',
  :host     => 'localhost',
  :database => 'encrypted_attributes_test',
  :username => 'root',
  :encoding => 'utf8'
})

class CreateSchema < ActiveRecord::Migration
  def self.up
    create_table :encrypto do |t|
      t.binary :description
    end
  end

  def self.down
    drop_table :encrypto
  end
end

RSpec.configure do |config|
  config.before(:suite) do
    CreateSchema.up
  end

  config.after(:each) do
    ActiveRecord::Base.connection.execute('TRUNCATE encrypto')
  end

  config.after(:suite) do
    CreateSchema.down
  end
end
