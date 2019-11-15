RSpec.describe Springcm::Document do
  let(:client) { Springcm::Client.new(data_center, client_id, client_secret) }
  let(:folder) { client.root_folder }
  let(:documents) { folder.documents }
  let(:document) { documents.items.first }

  context "document API" do
    before(:each) do
      client.connect!
    end

    it "can be reloaded" do
      expect(document.reload).to be_a(Springcm::Document)
    end

    it "can be deleted" do
      expect(document.delete).to be_a(Springcm::Document)
    end

    it "has attributes" do
      expect(document.attribute_groups).to be_a(Hash)
    end

    it "retrieves documents" do
      expect(documents.items).to all(be_a(Springcm::Document))
    end
  end
end
