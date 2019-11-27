module Springcm
  module Mixins
    # Mixin for objects that have attributes.
    module Attributes
      def deserialize_field(field)
        type = field["AttributeType"]
        value = field["Value"]
        if type == "String"
          value
        elsif type == "Number"
          value.to_i
        elsif type == "Decimal"
          value.to_f
        elsif type == "Date"
          Date.strptime(value[0..8], "%Y%m%d")
        else
          value
        end
      end

      def get_attribute(group:, field:)
        group_config = @client.account.all_attribute_groups.select { |g|
          g.name == group
        }.first
        # Non-existent group
        return nil if group_config.nil?
        field_config = group_config.field(field)
        field_set_config = group_config.set_for_field(field)
        # Non-existent field
        return nil if field_config.nil?
        groups = attribute_groups
        # No attribute groups applied
        return nil if groups.nil?
        group_data = groups.fetch(group, nil)
        # Group is not applied
        return nil if group_data.nil?
        # Repeating set
        if !field_set_config.nil? && field_set_config["RepeatingAttribute"]
          set_data = group_data.fetch(field_set_config["Name"], nil)
          set_data["Items"].map { |item|
            deserialize_field(item[field])
          }
        else
          field_data = group_data.fetch(field, nil)
          return nil if field_data.nil?
          deserialize_field(field_data)
        end
      end
    end
  end
end
