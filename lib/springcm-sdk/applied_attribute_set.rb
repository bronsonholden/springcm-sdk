require "springcm-sdk/object"
require "springcm-sdk/applied_attribute_set_item"
require "springcm-sdk/applied_attribute_field"

module Springcm
  class AppliedAttributeSet < Object
    attr_reader :subject
    attr_reader :group
    attr_reader :name

    def initialize(data, set_name, subject, group, client)
      @subject = subject
      @group = group
      @name = set_name
      super(data, client)
    end

    def field(field_name)
      # Validate name not one of the restricted attribute names:
      # RepeatingAttribute, AttributeType
      field_data = raw[field_name]
      # puts field_data
      if repeating_attribute == true
        raise RepeatableAttributeSetUsageError.new(group.name, name)
      else
        AppliedAttributeField.new(field_data, field_name, subject, group, self, @client)
      end
    end

    def [](*args)
      if repeating_attribute == true
        item = @data["Items"].send(:[], *args)
        AppliedAttributeSetItem.new(item, subject, group, self, @client)
      else
        raise NonRepeatableAttributeSetUsageError.new(group.name, name)
      end
    end

    def []=(key, data)
      if repeating_attribute == true
        raise NonRepeatableAttributeSetUsageError.new(group.name, name)
      end
      group_config = @client.account.attribute_group(name: group.name)
      set = group_config.set(name)
      item = @data["Items"][key]
      item.clear
      data.each { |key, value|
        field_config = group_config.field(key)
        item[key] = Helpers.serialize_field(field_config, value)
      }
      item
    end
  end
end
