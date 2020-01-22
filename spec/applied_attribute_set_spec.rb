RSpec.describe Springcm::AppliedAttributeSet do
  let(:client) { Springcm::Client.new(data_center, client_id, client_secret) }
  let(:document) { client.document(uid: UUID.generate) }
  let(:group) { document.attribute_group("Attribute Group") }
  let(:set) { group.set(set_name) }

  context "non-repeating set" do
    let(:set_name) { "Attribute Set" }

    describe "#field" do
      let(:field) { set.field("Attribute Set Field") }

      it "retrieves field" do
        expect(field).to be_a(Springcm::AppliedAttributeField)
      end
    end

    describe "#[]" do
      let(:set_item) { set[0] }

      it "raises error" do
        expect { set_item }.to raise_error(Springcm::NonRepeatableAttributeSetUsageError)
      end
    end
  end

  context "repeating set" do
    let(:set_name) { "Repeatable Attribute Set" }

    describe "#field" do
      let(:field) { set.field("Attribute Set Field") }

      it "raises error" do
        expect { field }.to raise_error(Springcm::RepeatableAttributeSetUsageError)
      end
    end

    describe "#[]" do
      let(:set_item) { set[0] }

      it "retrieves set item" do
        expect(set_item).to be_a(Springcm::AppliedAttributeSetItem)
      end
    end
  end
end
