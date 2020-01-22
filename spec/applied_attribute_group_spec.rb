RSpec.describe Springcm::AppliedAttributeGroup do
  let(:client) { Springcm::Client.new(data_center, client_id, client_secret) }
  let(:document) { client.document(uid: UUID.generate) }
  let(:group) { document.attribute_group(group_name) }

  describe "#attribute_group" do
    context "applied attribute group" do
      let(:group_name) { "Attribute Group" }

      it "retrieves attribute group" do
        expect(group).to be_a(Springcm::AppliedAttributeGroup)
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
