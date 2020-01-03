RSpec.describe Springcm::Document do
  let(:client) { Springcm::Client.new(data_center, client_id, client_secret) }
  let(:folder) { client.root_folder }
  let(:documents) { folder.documents }
  let(:document) { documents.items.first.reload }
  let(:history) { document.history }
  let(:trashy) { client.document(uid: "86592c45-e907-ea11-9c2b-3ca82a1e3f41") }
  let(:in_trash) { DocumentBuilder.new(client).delete!.build }

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

    describe "history items" do
      it "is a resource list" do
        expect(history).to be_a(Springcm::ResourceList)
        expect(history.next).to be_a(Springcm::ResourceList)
        expect(history.next.prev).to be_a(Springcm::ResourceList)
      end
    end
  end
end
