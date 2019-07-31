RSpec.describe Springcm::Document do
  let(:client) { Springcm::Client.new(data_center, client_id, client_secret) }
  let(:folder) { client.root_folder }
  let(:documents) { folder.documents }

  context "document API" do
    before(:each) do
      client.connect!
    end

    it "retrieves documents" do
      expect(documents).to all(be_a(Springcm::Document))
    end
  end
end
