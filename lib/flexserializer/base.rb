module Flexserializer
  class Base < ActiveModel::Serializer
    class << self
      attr_accessor :groups, :data_default_attributes

      def default_attributes(&block)
        self.data_default_attributes = block
      end

      def group(group_name, &block)
        self.groups           ||= {}
        self.groups[group_name] = block
      end
    end

    def initialize(object, options = {})
      define_attributes(options[:group])
      super(object, options)
    end

    def define_attributes(group)
      clear_data
      define_default_attrs
      define_group_attrs(group)
    end

    def clear_data
      self.class._attributes_data = {}
    end

    def define_default_attrs
      return if !self.class.data_default_attributes
      self.class.data_default_attributes.call
    end

    def define_group_attrs(group)
      return if !self.class.groups or !self.class.groups.keys.include?(group)
      self.class.groups[group].call
    end
  end
end