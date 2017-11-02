module Flexserializer
  class Base < ActiveModel::Serializer
    class << self
      attr_accessor :groups, :data_default_attributes

      def inherited(base)
        base.groups = {}
      end

      def default_attributes(&block)
        self.data_default_attributes = block
      end

      def group(*group_names, &block)
        group_names.each do |name_group|
          self.groups[name_group] ||= []
          self.groups[name_group] << block
        end
      end
    end

    attr_reader :group_name, :_attributes_data, :define_options

    def initialize(object, options = {})
      super(object, options)
      @_attributes_data = {}
      @group_name       = options[:group]
      @define_options   = options.clone
      make_all_attributes
    end

    def define_attributes(*attrs)
      attrs = attrs.first if attrs.first.class == Array
      attrs.each do |attr|
        define_attribute(attr)
      end
    end

    def define_attribute(attr, options = {}, &block)
      key = options.fetch(:key, attr)
      _attributes_data[key] = Attribute.new(attr, options, block)
    end

    def make_all_attributes
      define_default_attrs
      define_group_attrs
    end

    def define_default_attrs
      return unless self.class.data_default_attributes
      self.instance_eval &self.class.data_default_attributes
    end

    def define_group_attrs
      self.class.groups.send(:[], group_name)&.each do |block| 
        self.instance_eval(&block)
      end
    end

    #override serializer methods

    def attributes(requested_attrs = nil, reload = false)
      @attributes = nil if reload
      @attributes ||= _attributes_data.each_with_object({}) do |(key, attr), hash|
        next if attr.excluded?(self)
        next unless requested_attrs.nil? || requested_attrs.include?(key)
        hash[key] = attr.value(self)
      end
    end
  end
end