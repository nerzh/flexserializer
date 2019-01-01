## Flexserializer
# Conveniently structuring your attributes into groups for ActiveModelSerializer

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'flexserializer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install flexserializer

## Usage

```ruby
# default_attributes do
#   define_attributes :attr1, :attr2
#   define_attribute  :attr3
#   define_has_one    :attr4
#   define_has_many   :attr5
# end

class UserSerializer < Flexserializer::Base

  # Example default_attributes for all groups
  default_attributes do
    define_attributes :id, :name, :last_name
  end
  
  # Examples of the group definitions
  
  1) group can have many different names for flexible naming
  group(:with_names, :with_ages) do
    define_attribute :age
  end
  
  or
  
  2) single name
  group(:with_avatar) do
    define_attribute :avatar
  end
    
  # If you want to transfer the group name to the next Serializer.
  # define_options - hash with your options
  def avatar
    options = define_options.merge({group: :for_user})
    ActiveModelSerializers::SerializableResource.new(object.avatar, options).serializable_hash
  end
end
```

# Call group

for example
```ruby
class TestController < ApplicationController
  def index
    @hash = ActiveModelSerializers::SerializableResource.new(Model.all, {group: :group_name_1}).serializable_hash
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/flexserializer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Flexserializer project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/flexserializer/blob/master/CODE_OF_CONDUCT.md).
