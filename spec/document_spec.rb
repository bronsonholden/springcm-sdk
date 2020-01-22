RSpec.describe Springcm::Document do
  let(:client) { Springcm::Client.new(data_center, client_id, client_secret) }
  let(:folder) { client.root_folder }
  let(:documents) { folder.documents }
  let(:document) { documents.items.first.reload }
  let(:history) { document.history }
  let(:versions) { document.versions }
  let(:trashy) { client.document(uid: "86592c45-e907-ea11-9c2b-3ca82a1e3f41") }
  let(:in_trash) {
    doc = DocumentBuilder.new(client).uid(UUID.generate).build
    doc.delete
    doc.reload
  }

  context "document API" do
    before(:each) do
      client.connect!
    end

    it "can be reloaded" do
      expect(document.reload).to be_a(Springcm::Document)
    end

    it "can be deleted" do
      expect(trashy.delete).to be_a(Springcm::Document)
    end

    it "refuses to permanently delete" do
      expect { in_trash.delete }.to raise_error(Springcm::DeleteRefusedError)
    end

    it "allows explicit permanent deletion" do
      expect { in_trash.delete! }.not_to raise_error
    end

    it "has private unsafe delete" do
      expect { in_trash.unsafe_delete }.to raise_error(NoMethodError)
    end

    it "can be moved" do
      expect(trashy.move(path: "/")).to be_a(Springcm::Document)
    end

    it "has attributes" do
      expect(document.attribute_groups).to be_a(Hash)
    end

    it "retrieves documents" do
      expect(documents.items).to all(be_a(Springcm::Document))
    end

    describe "attributes" do
      let(:uid) { UUID.generate }
      let(:document) { DocumentBuilder.new(client).uid(uid).no_attributes!.build }

      it "applies attribute group" do
        doc = document
        doc.apply_attribute_group("Attribute Group")
        # puts doc.raw
        # expect(doc.attribute_group(name: "Attribute Group")).to be_a(Springcm::AppliedAttributeGroup)
      end
    end

    describe "download" do
      it "downloads file" do
        expect(document.download).to be_a(StringIO)
      end
    end

    describe "history items" do
      it "is a resource list" do
        expect(history).to be_a(Springcm::ResourceList)
        expect(history.next).to be_a(Springcm::ResourceList)
        expect(history.next.prev).to be_a(Springcm::ResourceList)
      end
    end

    describe "versions" do
      it "is a resource list" do
        expect(versions).to be_a(Springcm::ResourceList)
        expect(versions.next).to be_a(Springcm::ResourceList)
        expect(versions.next.prev).to be_a(Springcm::ResourceList)
        expect(versions.items).to all(be_a(Springcm::Document))
      end
    end

    context "versioned" do
      let(:versioned) { DocumentBuilder.new(client).version(2) }
      let(:document_version) { versioned.build }

      it "includes Version" do
        expect(document_version.version).to eq("2.0")
      end

      it "does not include HistoryItems" do
        expect { document_version.history_items }.to raise_error(NoMethodError)
      end

      it "includes AttributeGroups" do
        expect { document_version.attribute_groups }.not_to raise_error
      end

      it "includes Path" do
        expect { document_version.path }.not_to raise_error
      end
    end
  end
end
