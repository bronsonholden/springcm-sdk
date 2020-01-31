require "springcm-sdk/applied_attribute_group"
require "springcm-sdk/applied_attribute_set"
require "springcm-sdk/applied_attribute_set_item"
require "springcm-sdk/applied_attribute_field"
require "springcm-sdk/helpers"

module Springcm
  module Mixins
    # Mixin for objects that have attributes.
    module Attributes
      def attribute_groups=(value)
        @data["AttributeGroups"] = value
      end

      def attribute_group(group_name)
        groups = @data["AttributeGroups"] || get.attribute_groups || {}
        group_data = groups[group_name]
        if group_data.nil?
          nil
        else
          AppliedAttributeGroup.new(group_data, group_name, self, @client)
        end
      end

      # Apply a skeleton attribute group to the Document object. Calling #patch
      # or #put before actually applying any data will have no effect on the
      # document within SpringCM.
      def apply_attribute_group(group_name)
        return if !attribute_group(group_name).nil?
        group_config = @client.account.attribute_group(name: group_name)
        @data["AttributeGroups"] ||= {}
        @data["AttributeGroups"].merge!({ "#{group_name}" => group_config.template })
      end
    end
  end
end
