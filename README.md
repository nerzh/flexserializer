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
    attributes :id, :title, :description
  end
  
  # ----- example group :for_list
  group(:for_list) do
    attributes :small_description, :product_count
  end
    # or same
  group(:for_list) do
    attribute :small_description
    attribute :product_count
  end
    
  # ----- example group :with_products
  group(:with_products) do
    attributes :small_description, :images
    has_many :products
  end
    
  # If you want to transfer the group name to the next Serializer 
  def images
    options = instance_options[:group] ? {group: instance_options[:group]} : {}
    ActiveModelSerializers::SerializableResource.new(object.images, options).serializable_hash
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/flexserializer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Flexserializer project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/flexserializer/blob/master/CODE_OF_CONDUCT.md).
