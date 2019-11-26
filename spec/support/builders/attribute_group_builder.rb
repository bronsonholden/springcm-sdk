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
      "Attributes" => attributes,
      "Href" => "#{client.object_api_url}/attributegroups/#{uid}"
    }
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
            "Name" => "Set Field",
            "RepeatingAttribute" => false
          }
        ],
        "Name" => "Set",
        "RepeatingAttribute" => false
      }
    ]
  end
end
