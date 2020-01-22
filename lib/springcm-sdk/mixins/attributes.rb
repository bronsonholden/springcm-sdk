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

      # TODO: Clean this whole mess up. This pattern sucks. Better:
      #         doc = client.document(...)
      #         group = doc.attribute_group("My Data")
      #         attr = group.attribute("My Field")
      #         attr.type
      #         attr.repeating?
      #         attr.value
      #         attr.value = 2
      #         attr.value = [1, 2, 3]
      #         attr.value[0] = 3
      #         attr.insert(at: 0, value: 5)
      #         doc.patch

      def set_attribute(group:, field:, index: nil, value:, mode: :insert)
        if ![:insert, :replace].include?(mode)
          raise ArgumentError.new("Set attribute mode must be one of: :insert, :replace")
        end
        if mode == :replace && (index.nil? || index < 0)
          raise ArgumentError.new("When set attribute mode is :replace, index must be a non-negative integer")
        end
        group_config = @client.account.all_attribute_groups.select { |g|
          g.name == group
        }.first
        # Non-existent group
        raise Springcm::NoAttributeGroupError.new(group) if group_config.nil?
        field_config = group_config.field(field)
        field_set_config = group_config.set_for_field(field)
        # Non-existent field
        raise Springcm::NoAttributeFieldError.new(group, field) if field_config.nil?
        groups = attribute_groups || {}
        group_data = groups.fetch(group, {})
        # Repeating set
        if !field_set_config.nil? && field_set_config["RepeatingAttribute"]
          set_name = field_set_config["Name"]
          set_data = group_data.fetch(set_name, { "Items"=>[] })
          field_data = {
            "#{field}" => Springcm::Helpers.serialize_field(field_config, value)
          }
          if mode == :insert
            set_data["Items"].insert(index || -1, field_data)
          elsif
            set = set_data["Items"][index] || {}
            set.merge!(field_data)
          end
          set_data["Items"][index] = set
          set_data["Items"].reject!(&:nil?)
          group_data[set_name] = set_data
        else
          serialized = Springcm::Helpers.serialize_field(field_config, value)
          if field_config.repeating_attribute?
            if mode == :insert
              group_data[field]["Value"].insert(index || -1, serialized["Value"])
            else
              group_data[field]["Value"][index] = serialized["Value"]
            end
            group_data[field]["Value"].reject!(&:nil?)
          else
            group_data[field] = serialized
          end
        end
        groups[group] = group_data
        attribute_groups = groups
        value
      end

      def get_attribute(group:, field:)
        group_config = @client.account.all_attribute_groups.select { |g|
          g.name == group
        }.first
        # Non-existent group
        raise Springcm::NoAttributeGroupError.new(group) if group_config.nil?
        field_config = group_config.field(field)
        field_set_config = group_config.set_for_field(field)
        # Non-existent field
        raise Springcm::NoAttributeFieldError.new(group, field) if field_config.nil?
        groups = attribute_groups
        # No attribute groups applied
        return nil if groups.nil?
        group_data = groups.fetch(group, nil)
        # Group is not applied
        return nil if group_data.nil?
        # Repeating set
        if !field_set_config.nil? && field_set_config["RepeatingAttribute"]
          set_data = group_data.fetch(field_set_config["Name"], nil)
          return nil if set_data.nil?
          set_data["Items"].map { |item|
            Springcm::Helpers.deserialize_field(item[field])
          }
        else
          field_data = group_data.fetch(field, nil)
          return nil if field_data.nil?
          Springcm::Helpers.deserialize_field(field_data)
        end
      end
    end
  end
end
