module Springcm
  module Helpers
    # Validate an offset and limit pair.
    def self.validate_offset_limit!(offset, limit)
      if !limit.is_a?(Integer) || limit < 1 || limit > 1000
        raise ArgumentError.new("Limit must be an integer between 1 and 1000 (inclusive).")
      end

      if !offset.is_a?(Integer) || offset < 0
        raise ArgumentError.new("Offset must be a positive, non-zero integer.")
      end
    end

    def self.serialize_field(field_config, value)
      type = field_config.type
      repeating = field_config.repeating_attribute?
      serialized = {
        "AttributeType" => type,
        "RepeatingAttribute" => repeating
      }
      serialized_value = nil
      if type == "Date"
        # Raise if value is not a DateTime
        serialized_value = value.strftime("%m/%d/%Y")
      else
        serialized_value = value.to_s
      end
      return nil if serialized_value.nil?
      serialized["Value"] = serialized_value
      serialized
    end

    # Deserialize a SpringCM attribute value
    def self.deserialize_field(field)
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

    def self.validate_access!(access)
      access_types = [
        :inherit_from_parent_folder,
        :no_access,
        :view,
        :view_create,
        :view_edit,
        :view_edit_delete,
        :view_edit_delete_set_access
      ]
      if !access_types.include?(access)
        raise ArgumentError.new("Access must be one of: #{access_types.map(&:inspect).join(", ")}")
      end
    end
  end
end
