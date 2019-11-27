require "springcm-sdk/resource"
require "springcm-sdk/attribute"

module Springcm
  # A configured attribute group in SpringCM.
  class AttributeGroup < Resource
    # Retrieve an attribute set by name.
    def set(name)
      res = @data["Attributes"].select { |attr|
        attr["Attributes"].is_a?(Array) && attr["Name"] == name
      }
      return nil if !res.any?
      res.first["Attributes"].map { |attr|
        Attribute.new(attr, @client)
      }
    end

    # Retrieve an attribute field by name.
    def field(name)
      res = attributes.select { |attr|
        attr["Name"] == name
      }
      return nil if !res.any?
      # TODO: Assert only one result
      Attribute.new(res.first, @client)
    end

    def set_for_field(name)
      if sets.map { |set| set["Name"] }.include?(name)
        return nil
      end
      sets.each { |set|
        if set["Attributes"].map { |attr| attr["Name"] }.include?(name)
          return set
        end
      }
      nil
    end

    def attributes
      @data["Attributes"].map { |attr|
        if attr["Attributes"].is_a?(Array)
          attr["Attributes"]
        else
          [attr]
        end
      }.flatten
    end

    def sets
      @data["Attributes"].select { |attr|
        attr["Attributes"].is_a?(Array)
      }
    end
  end
end
