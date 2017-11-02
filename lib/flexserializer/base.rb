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

    attr_reader :group_name, :_attributes_data, :_reflections

    def initialize(object, options = {})
      super(object, options)
      @_attributes_data = {}
      @_reflections     = {}
      @group_name       = options[:group]
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

    def define_default_attrs
      return unless self.class.data_default_attributes
      self.instance_eval &self.class.data_default_attributes
    end

    def define_group_attrs
      self.class.groups.send(:[], group_name)&.each do |block| 
        self.instance_eval(&block)
      end
    end

    def define_has_many(name, options = {}, &block)
      define_associate(HasManyReflection.new(name, options, block))
    end

    def define_belongs_to(name, options = {}, &block)
      define_associate(BelongsToReflection.new(name, options, block))
    end

    def define_has_one(name, options = {}, &block)
      define_associate(HasOneReflection.new(name, options, block))
    end

    def define_options
      instance_options
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

    def associations(include_directive = ActiveModelSerializers.default_include_directive, include_slice = nil)
      include_slice ||= include_directive
      return Enumerator.new unless object

      Enumerator.new do |y|
        _reflections.each do |key, reflection|
          next if reflection.excluded?(self)
          next unless include_directive.key?(key)

          association = reflection.build_association(self, instance_options, include_slice)
          y.yield association
        end
      end
    end

    private

    def make_all_attributes
      define_default_attrs
      define_group_attrs
    end

    def define_associate(reflection)
      key = reflection.options[:key] || reflection.name
      _reflections[key] = reflection
    end
  end
end