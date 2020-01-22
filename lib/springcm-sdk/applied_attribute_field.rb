require "springcm-sdk/object"

module Springcm
  class AppliedAttributeField < Object
    attr_reader :subject
    attr_reader :group
    attr_reader :set
    attr_reader :name

    def initialize(data, field_name, subject, group, set, client)
      @subject = subject
      @group = group
      @set = set
      @name = field_name
      super(data, client)
    end

    def value
      if repeating_attribute == true
        raise RepeatableAttributeFieldUsageError.new(group.name, name)
      else
        Helpers.deserialize_field(raw)
      end
    end

    def value=(val)
      if repeating_attribute == true
        raise RepeatableAttributeFieldUsageError.new(group.name, name)
      else
        @data["Value"] = Helpers.serialize_value(@data["AttributeType"], val)
      end
    end

    def [](*args)
      if repeating_attribute == true
        Helpers.deserialize_value(@data["AttributeType"], @data["Value"].send(:[], *args))
      else
        raise NonRepeatableAttributeFieldUsageError.new(group.name, name)
      end
    end

    def []=(key, val)
      if repeating_attribute == true
        @data["Value"].send(:[]=, key, val)
      else
        raise NonRepeatableAttributeFieldUsageError.new(group.name, name)
      end
    end
  end
end
