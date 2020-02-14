require "springcm-sdk/object"
require "springcm-sdk/applied_attribute_set"

module Springcm
  class AppliedAttributeGroup < Object
    attr_reader :subject
    attr_reader :name

    def initialize(data, group_name, subject, client)
      @subject = subject
      @name = group_name
      super(data, client)
    end

    def set(set_name)
      set_data = raw[set_name]
      if set_data.nil? || set_data["AttributeType"] != "Set"
        raise NoAttributeSetError.new(group.name, name)
      end
      AppliedAttributeSet.new(set_data, set_name, subject, self, @client)
    end

    def field(field_name)
      group_config = @client.account.attribute_group(name: name)
      set_config = group_config.set_for_field(field_name)
      field_data = nil
      if set_config.nil?
        field_data = raw[field_name]
      elsif set_config["RepeatingAttribute"]
        raise RepeatableAttributeSetUsageError.new(group.name, name)
      else
        field_data = raw[set_config["Name"]][field_name]
      end
      AppliedAttributeField.new(field_data, field_name, subject, self, nil, @client)
    end
  end
end
