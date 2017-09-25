module Flexserializer
  class Base < ActiveModel::Serializer
    class << self
    attr_accessor :groups, :data_default_attributes

    def default_attributes(*attrs)
      attrs = attrs.first if attrs.first.class == Array
      self.data_default_attributes = attrs
    end

    def group(group_name, &block)
      self.groups           ||= {}
      self.groups[group_name] = block
    end
  end

  def initialize(object, options = {})
    self.class.data_default_attributes ||= []
    define_attributes(options[:group])
    super(object, options)
  end

  def define_attributes(group)
    clear_data
    define_default_attrs
    return unless self.class.groups.keys.include?(group)
    define_group_attrs(group)
  end

  def clear_data
    self.class._attributes_data = {}
  end

  def define_default_attrs
    self.class.data_default_attributes = self.class.data_default_attributes.first if self.class.data_default_attributes.first.class == Array
    self.class.data_default_attributes.each { |attr| self.class.attribute(attr) }
  end

  def define_group_attrs(group)
    self.class.groups[group].call
  end
end