$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'bundler/setup'

require 'pry'
require 'active_record'
require 'mysql2'
require 'encrypted-column'

ActiveRecord::Base.establish_connection({
  :adapter  => 'mysql2',
  :host     => 'localhost',
  :database => 'aes_test',
  :username => 'aes_test',
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
