# Flexserializer

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
class CatalogSerializer < Flexserializer::Base
  # ----- example default_attributes
  default_attributes do
    attributes :attribute_8, :attribute_9, :attribute_10
  end
  
  # Examples of the group definitions
  
  1)
  group(:group_name_1) do
    attributes :attribute_1
  end

  2)
  group(:group_name_2, :group_name_3) do
    attributes :attribute_1, ::attribute_2
    attribute  :attribute_3
    has_one :attribute_4
    has_may ::attribute_5
    ...
  end
    
  # If you want to transfer the group name to the next Serializer 
  def attribute_3
    options = instance_options[:group] ? {group: instance_options[:group]} : {}
    ActiveModelSerializers::SerializableResource.new(object.images, options).serializable_hash
  end
end
```

# Call group

for example
```ruby
class TestController < ApplicationController
  def index
    @hash = ActiveModelSerializers::SerializableResource.new(Model.all, {group: :group_name_3}).serializable_hash
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/flexserializer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Flexserializer project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/flexserializer/blob/master/CODE_OF_CONDUCT.md).
