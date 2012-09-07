require 'spec_helper'

describe SimpleAES do
  let(:key)     { 'e0cfe841f51d29c0e0a1c51391ca04a6' }
  let(:iv)      { '7b94eae611106dc190b10f40e2d0fde0' }

  it "allows you to simply encrypt data" do
    encrypted = SimpleAES.new(:key => key, :iv => iv).encrypt('foo bar')
    encrypted.should == '99ea4886246cb6ad15c236a2e5935af2'
  end

  it "allows you to decrypt data" do
    message = '5e3a1d405c66f4541a0618bb9e428db9'
    SimpleAES.new(:key => key, :iv => iv).decrypt(message).should == 'you got it!'
  end
end
