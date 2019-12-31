# Builder for SpringCM AttributeGroups (the definitions, not the actual data
# applied to Documents and/or Folders).
class AttributeGroupBuilder < Builder
  property :name, type: String, default: "Attribute Group"
  property :is_system, default: false, validate: -> (*args) {
    if ![true, false].include?(args.first)
      raise ArgumentError.new("IsSystem must be true or false")
    end
  }
  property :uid, type: String, default: UUID.generate

  def build
    Springcm::AttributeGroup.new(data, client)
  end

  def data
    {
      "Name" => name,
      "IsSystem" => false,
      "Attributes" => attributes,
      "Href" => "#{client.object_api_url}/attributegroups/#{uid}"
    }
  end

  def itemized_data
    data.reject { |key| ["Attributes"].include?(key) }
  end

  def attributes
    # TODO: Dynamically build attributes?
    [
      {
        "Required" => false,
        "ReadOnly" => false,
        "Type" => "String",
        "Name" => "Field",
        "RepeatingAttribute" => false
      },
      {
        "Attributes" => [
          {
            "Required" => false,
            "ReadOnly" => false,
            "Type" => "String",
            "Name" => "Attribute Set Field",
            "RepeatingAttribute" => false
          }
        ],
        "Name" => "Attribute Set",
        "RepeatingAttribute" => false
      },
      {
        "Attributes" => [
          {
            "Required" => false,
            "ReadOnly" => false,
            "Type" => "String",
            "Name" => "Repeatable Attribute Set Field",
            "RepeatingAttribute" => false
          }
        ],
        "Name" => "Repeatable Attribute Set",
        "RepeatingAttribute" => true
      },
      {
        "Required" => false,
        "ReadOnly" => false,
        "Type" => "String",
        "Name" => "Repeatable Field",
        "RepeatingAttribute" => true
      },
      {
        "Required" => false,
        "ReadOnly" => false,
        "Type" => "Number",
        "Name" => "Number Field",
        "RepeatingAttribute" => false
      },
      {
        "Required" => false,
        "ReadOnly" => false,
        "Type" => "Date",
        "Name" => "Date Field",
        "RepeatingAttribute" => false
      },
      {
        "Required" => false,
        "ReadOnly" => false,
        "Type" => "DropDown",
        "PicklistValues" => [
          "Option 1",
          "Option 2",
          "Option 3"
        ],
        "Name" => "Drop Down Field",
        "RepeatingAttribute" => false
      },
      {
        "Required" => false,
        "ReadOnly" => false,
        "Type" => "Decimal",
        "Name" => "Decimal Field",
        "RepeatingAttribute" => false
      },
      {
        "Required" => false,
        "ReadOnly" => true,
        "Type" => "AutoNumber",
        "Name" => "Auto Number Field",
        "RepeatingAttribute" => false
      },
      {
        "Required" => false,
        "ReadOnly" => false,
        "Type" => "DynamicDropDown",
        "PicklistValues" => [
          "Dynamic Option 1",
          "Dynamic Option 2"
        ],
        "Name" => "Dynamic Drop Down Field",
        "RepeatingAttribute" => false
      },
      {
        "Attributes" => [
          {
            "Required" => false,
            "ReadOnly" => false,
            "Type" => "Cascade",
            "PicklistValuesHref" => "https =>//apiuatna11.springcm.com/v201411/customdata/9da00c25-4f0d-ea11-b808-48df378a7098",
            "Name" => "Cascading Field 1",
            "RepeatingAttribute" => false
          },
          {
            "Required" => false,
            "ReadOnly" => false,
            "Type" => "Cascade",
            "PicklistValuesHref" => "https =>//apiuatna11.springcm.com/v201411/customdata/9da00c25-4f0d-ea11-b808-48df378a7098?filter=Cascading%20Field%201%3D{?Cascading Field 1}",
            "Name" => "Cascading Field 2",
            "RepeatingAttribute" => false
          },
          {
            "Required" => false,
            "ReadOnly" => false,
            "Type" => "String",
            "Name" => "Cascading Extension Field",
            "RepeatingAttribute" => false
          }
        ],
        "Name" => "Cascading Attribute Set",
        "RepeatingAttribute" => false
      }
    ]
  end
end
