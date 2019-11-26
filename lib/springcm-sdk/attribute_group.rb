require "springcm-sdk/resource"
require "springcm-sdk/attribute"

module Springcm
  class AttributeGroup < Resource
    def set(name)
      res = attributes.select { |attr|
        attr["Attributes"].is_a?(Array) && attr["Name"] == name
      }
      return nil if !res.any?
      res.first["Attributes"].map { |attr|
        Attribute.new(attr, @client)
      }
    end

    def field(name)
      res = attributes.select { |attr|
        attr["Name"] == name
      }
      return nil if !res.any?
      # TODO: Assert only one result
      Attribute.new(res.first, @client)
    end
  end
end
