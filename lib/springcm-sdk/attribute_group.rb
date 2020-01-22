require "springcm-sdk/resource"
require "springcm-sdk/attribute"

module Springcm
  # A configured attribute group in SpringCM.
  class AttributeGroup < Resource
    # Retrieve an attribute set by name.
    def set(name)
      res = attributes_config.select { |attr|
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
      attributes_config.map { |attr|
        if attr["Attributes"].is_a?(Array)
          attr["Attributes"]
        else
          [attr]
        end
      }.flatten
    end

    def sets
      attributes_config.select { |attr|
        attr["Attributes"].is_a?(Array)
      }
    end

    def template
      group = {}
      attributes_config.each { |attribute|
        type = attribute["Type"]
        if type == "DynamicDropDown"
          type = "MagicDropdown" # Not sure why they do this for applied groups, but oh well
        end
        repeating = attribute["RepeatingAttribute"]
        attr = {
          "AttributeType" => type,
          "RepeatingAttribute" => repeating
        }
        if attribute.key?("Attributes") # If it's a set
          attr["AttributeType"] = "Set"
          set = attr
          if repeating
            set = {}
            attr["Items"] = [set]
          end
          attribute["Attributes"].each { |field|
            set[field["Name"]] = {
              "AttributeType" => field["Type"],
              "RepeatingAttribute" => false
            }
          }
        elsif repeating
          # Must have empty array for repeating plain fields
          attr["Value"] = []
        end
        group[attribute["Name"]] = attr
      }
      group
    end

    protected

    def attributes_config
      @data = reload.raw if !@data.key?("Attributes")
      @data["Attributes"]
    end
  end
end
