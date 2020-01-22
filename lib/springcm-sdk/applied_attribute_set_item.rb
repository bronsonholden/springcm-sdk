require "springcm-sdk/object"
require "springcm-sdk/applied_attribute_field"

module Springcm
  class AppliedAttributeSetItem < Object
    attr_reader :subject
    attr_reader :group
    attr_reader :name

    def initialize(data, subject, group, set, client)
      @subject = subject
      @group = group
      super(data, client)
    end

    def field(field_name)
      # Validate name not one of the restricted attribute names:
      # RepeatingAttribute, AttributeType
      field_data = raw[field_name]
      AppliedAttributeField.new(field_data, field_name, subject, group, set, @client)
    end
  end
end
