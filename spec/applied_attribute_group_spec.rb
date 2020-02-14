RSpec.describe Springcm::AppliedAttributeGroup do
  let(:client) { Springcm::Client.new(data_center, client_id, client_secret) }
  let(:document) { client.document(uid: UUID.generate) }
  let(:group) { document.attribute_group(group_name) }

  describe "#attribute_group" do
    shared_examples "retrieve_field" do
      it "retrieves applied field" do
        expect(group.field(field_name)).to be_a(Springcm::AppliedAttributeField)
      end
    end
    context "applied attribute group" do
      let(:group_name) { "Attribute Group" }

      it "retrieves attribute group" do
        expect(group).to be_a(Springcm::AppliedAttributeGroup)
      end

      describe "#field" do
        context "cascading set field" do
          let(:field_name) { "Cascading Field 1" }
          include_examples "retrieve_field"
        end

        context "basic field" do
          let(:field_name) { "Field" }
          include_examples "retrieve_field"
        end

        context "set field" do
          let(:field_name) { "Attribute Set Field" }
          include_examples "retrieve_field"
        end

        context "repeatable field" do
          let(:field_name) { "Repeatable Field" }
          include_examples "retrieve_field"
        end
      end
    end

    context "non-applied attribute group" do
      let(:group_name) { "Not Attribute Group" }

      it "returns nil" do
        expect(group).to be_nil
      end
    end
  end
end
