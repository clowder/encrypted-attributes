[![Build Status](https://secure.travis-ci.org/clowder/encrypted-attributes.png)](http://travis-ci.org/clowder/encrypted-attributes)

# EncryptedAttributes

## Usage

### Rails

Create an initializer that will configure the EncryptedAttributes module with your Key and IV.

```
EncryptedAttributes.setup(:key => 'YOUR RANDOM KEY', :iv => 'YOUR RANDOM INITIALIZATION VECTOR')
```

Encrypt your columns like.

```ruby
class Deployment < ActiveRecord::Base
  extend EncryptedAttributes

  serialize :secret_config, Hash
  encrypt :secret_config
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
