RSpec.describe Springcm::AppliedAttributeField do
  let(:client) { Springcm::Client.new(data_center, client_id, client_secret) }
  let(:document) { client.document(uid: UUID.generate) }
  let(:group) { document.attribute_group("Attribute Group") }

  shared_examples "repeating_field_examples" do
    describe "#field" do
      it "raises error" do
        expect { field.value }.to raise_error(Springcm::RepeatableAttributeFieldUsageError)
      end
    end

    describe "#field=" do
      it "raises error" do
        expect { field.value = "New Value" }.to raise_error(Springcm::RepeatableAttributeFieldUsageError)
      end
    end

    describe "#[]" do
      it "returns value" do
        expect(field[0]).not_to be_nil
      end
    end

    describe "#[]=" do
      it "sets value" do
        field[0] = "New Value"
        expect(field[0]).to eq("New Value")
      end
    end
  end

  shared_examples "non_repeating_field_examples" do
    describe "#field" do
      it "returns value" do
        expect(field.value).not_to be_nil
      end
    end

    describe "#field=" do
      it "sets value" do
        field.value = "New Value"
        expect(field.value).to eq("New Value")
      end
    end

    describe "#[]" do
      it "raises error" do
        expect { field[0] }.to raise_error(Springcm::NonRepeatableAttributeFieldUsageError)
      end
    end

    describe "#[]=" do
      it "raises error" do
        expect { field[0] = "New Value" }.to raise_error(Springcm::NonRepeatableAttributeFieldUsageError)
      end
    end
  end

  context "non-set" do
    context "non-repeating field" do
      let(:field) { group.field("Field") }

      include_examples "non_repeating_field_examples"
    end

    context "repeating field" do
      let(:field) { group.field("Repeatable Field") }

      include_examples "repeating_field_examples"
    end
  end

  context "set" do
    let(:set) { group.set("Attribute Set") }

    context "field" do
      let(:field) { set.field("Attribute Set Field") }

      include_examples "non_repeating_field_examples"
    end
  end
end
