require 'openssl'

class SimpleAES
  attr_reader :cipher, :key, :iv

  def initialize(args={})
    @key    = args.fetch(:key)
    @iv     = args.fetch(:iv)
    @cipher = args[:cypher] || 'AES-128-CBC'
  end

  def decrypt(encrypted_data)
    encrypted_data = Array(encrypted_data).pack('H*')
    aes = OpenSSL::Cipher::Cipher.new(cipher)
    aes.decrypt
    aes.key = key
    aes.iv = iv
    aes.update(encrypted_data) + aes.final
  end

  def encrypt(data)
    aes = OpenSSL::Cipher::Cipher.new(cipher)
    aes.encrypt
    aes.key = key
    aes.iv = iv
    (aes.update(data) + aes.final).unpack('H*').first
  end
end
