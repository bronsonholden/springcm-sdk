RSpec.describe Springcm::Client do
  def self.test_valid_data_center(data_center)
    context data_center do
      let(:data_center) { data_center }
      it "successfully creates client" do
        expect { client }.not_to raise_error
      end
    end
  end

  let(:client) { Springcm::Client.new(data_center, client_id, client_secret) }

  test_valid_data_center "uatna11"
  test_valid_data_center "na11"

  context "with invalid data center" do
    let(:data_center) { "narnia" }
    it "raises connection info error" do
      expect { client }.to raise_error(Springcm::ConnectionInfoError)
    end
  end

  describe "object API URL helpers" do
    it "returns valid object URL" do
      expect(client.object_api_url).to eq("https://apiuatna11.springcm.com/v201411")
    end
    it "returns valid content download URL" do
      expect(client.download_api_url).to eq("https://apidownloaduatna11.springcm.com/v201411")
    end
    it "returns valid content upload URL" do
      expect(client.upload_api_url).to eq("https://apiuploaduatna11.springcm.com/v201411")
    end
  end

  describe "auth URL helper" do
    context "UAT data center" do
      it "returns valid auth API URL" do
        expect(client.auth_url).to eq("https://authuat.springcm.com/api/v201606/apiuser")
      end
    end

    context "production data center" do
      let(:data_center) { "na11" }
      it "returns valid auth API URL" do
        expect(client.auth_url).to eq("https://auth.springcm.com/api/v201606/apiuser")
      end
    end
  end

  describe "authentication" do
    context "with valid credentials" do
      it "is successful" do
        client.connect
        expect(client.authenticated?).to eq(true)
      end
    end
    context "with invalid credentials" do
      let(:client_id) { "sandman" }
      it "fails quietly" do
        client.connect
        expect(client.authenticated?).to eq(false)
      end
      it "fails loudly" do
        expect { client.connect! }.to raise_error(Springcm::InvalidClientIdOrSecretError)
      end
    end
  end

  describe "folder usage" do
    let(:folder) { client.root_folder }
    it "retrieves root folder" do
      expect(folder).to be_a(Springcm::Folder)
    end
  end
end
