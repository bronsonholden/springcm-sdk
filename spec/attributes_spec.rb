RSpec.describe Springcm::Mixins::Attributes do
  class HasAttributes
    include Springcm::Mixins::Attributes

    def initialize(client)
      @client = client
    end
  end

  let(:attribute_groups_data) {
    {
      "Attribute Group" => {
        "Field" => {
          "AttributeType" => "String",
          "RepeatingAttribute" => false,
          "Value" => "A"
        },
        "Attribute Set" => {
          "AttributeType" => "Set",
          "RepeatingAttribute" => false,
          "Attribute Set Field" => {
            "AttributeType" => "String",
            "RepeatingAttribute" => false,
            "Value" => "B"
          }
        },
        "Repeatable Attribute Set" => {
          "Items" => [
            {
              "Repeatable Attribute Set Field" => {
                "AttributeType" => "String",
                "RepeatingAttribute" => false,
                "Value" => "1"
              }
            },
            {
              "Repeatable Attribute Set Field" => {
                "AttributeType" => "String",
                "RepeatingAttribute" => false,
                "Value" => "2"
              }
            },
            {
              "Repeatable Attribute Set Field" => {
                "AttributeType" => "String",
                "RepeatingAttribute" => false,
                "Value" => "3"
              }
            }
          ],
          "AttributeType" => "Set",
          "RepeatingAttribute" => true
        },
        "Repeatable Field" => {
          "AttributeType" => "String",
          "RepeatingAttribute" => true,
          "Value" => [
            "R1",
            "R2",
            "R3"
          ]
        },
        "Number Field" => {
          "AttributeType" => "Number",
          "RepeatingAttribute" => false,
          "Value" => "123"
        },
        "Date Field" => {
          "AttributeType" => "Date",
          "RepeatingAttribute" => false,
          "Value" => "20191101000000"
        },
        "Drop Down Field" => {
          "AttributeType" => "DropDown",
          "RepeatingAttribute" => false,
          "Value" => "Option 1"
        },
        "Decimal Field" => {
          "AttributeType" => "Decimal",
          "RepeatingAttribute" => false,
          "Value" => "1.22"
        },
        "Auto Number Field" => {
          "AttributeType" => "AutoNumber",
          "RepeatingAttribute" => false,
          "Value" => "6"
        },
        "Dynamic Drop Down Field" => {
          "AttributeType" => "MagicDropDown",
          "RepeatingAttribute" => false,
          "Value" => "Dynamic Option 1"
        },
        "Cascading Attribute Set" => {
          "AttributeType" => "Set",
          "RepeatingAttribute" => false,
          "Cascading Field 1" => {
            "AttributeType" => "Cascade",
            "RepeatingAttribute" => false,
            "Value" => "Cascading Value 1.1"
          },
          "Cascading Field 2" => {
            "AttributeType" => "Cascade",
            "RepeatingAttribute" => false,
            "Value" => "Cascading Value 1.2"
          },
          "Cascading Extension Field" => {
            "AttributeType" => "String",
            "RepeatingAttribute" => false,
            "Value" => "Ext"
          }
        }
      }
    }
  }

  let(:client) { Springcm::Client.new(data_center, client_id, client_secret) }

  let(:object) {
    obj = HasAttributes.new(client)
    allow(obj).to receive(:attribute_groups).and_return(attribute_groups_data)
    obj
  }

  let(:group_name) { "Attribute Group" }
  let(:field_name) { "Attribute Field" }
  let(:get_value) { object.get_attribute(group: group_name, field: field_name) }
  let(:set_value) { nil }
  let(:index) { nil }
  let(:new_value) { object.set_attribute(group: group_name, field: field_name, index: index, value: set_value ) }
  let(:klass) { NilClass }

  shared_examples "attributes" do
    describe "get" do
      it "returns value" do
        expect(get_value).to be_a(klass)
      end
    end

    describe "set" do
      it "applies new value" do
        expect(new_value).to eq(set_value)
      end
    end
  end

  describe "number field" do
    let(:field_name) { "Number Field" }
    let(:klass) { Integer }
    let(:set_value) { 1 }
    include_examples "attributes"
  end

  describe "decimal field" do
    let(:field_name) { "Decimal Field" }
    let(:klass) { Float }
    let(:set_value) { 1.5883 }
    include_examples "attributes"
  end

  describe "date field" do
    let(:field_name) { "Date Field" }
    let(:klass) { Date }
    let(:set_value) { Date.new(2010, 1, 1) }
    include_examples "attributes"
  end
end
