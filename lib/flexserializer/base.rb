module Flexserializer
  class Base < ActiveModel::Serializer
    class << self
      attr_accessor :groups, :data_default_attributes

      def default_attributes(&block)
        self.data_default_attributes = block
      end

      def group(*group_names, &block)
        self.groups ||= {}
        group_names.each do |name_group|
          self.groups[name_group] ||= []
          self.groups[name_group] << block
        end
      end
    end

    attr_reader :group_name
    
    def initialize(object, options = {})
      @group_name = options[:group]
      define_attributes
      super(object, options)
    end

    def define_attributes
      clear_data
      define_default_attrs
      define_group_attrs
    end

    def clear_data
      self.class._attributes_data = {}
    end

    def define_default_attrs
      return unless self.class.data_default_attributes
      self.class.data_default_attributes.call
    end

    def define_group_attrs
      return unless self.class.groups or self.class.groups.keys.include?(group_name)
      self.class.groups[group_name].each { |block| block.call }
    end
  end
end