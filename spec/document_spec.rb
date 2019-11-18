RSpec.describe Springcm::Document do
  let(:client) { Springcm::Client.new(data_center, client_id, client_secret) }
  let(:folder) { client.root_folder }
  let(:documents) { folder.documents }
  let(:document) { documents.items.first }
  let(:trashy) { client.document(uid: "86592c45-e907-ea11-9c2b-3ca82a1e3f41") }

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

    it "can be moved" do
      expect(trashy.move("/")).to be_a(Springcm::Document)
    end

    it "has attributes" do
      expect(document.attribute_groups).to be_a(Hash)
    end

    it "retrieves documents" do
      expect(documents.items).to all(be_a(Springcm::Document))
    end
  end
end
