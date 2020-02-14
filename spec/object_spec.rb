RSpec.describe Springcm::Object do
  let(:client) { Springcm::Client.new(data_center, client_id, client_secret) }
  let(:object) { Springcm::Object.new(data, client) }
  let(:data) {
    {
      "Name" => "My Document Name"
    }
  }

  describe "getter method missing" do
    it "retrieves value" do
      expect(object.name).to eq("My Document Name")
    end

    it "falls back to super" do
      expect { object.nothing }.to raise_error(NoMethodError)
    end
  end

  describe "setter method missing" do
    let(:new_name) { "My New Document Name" }
    it "sets new value" do
      object.name = new_name
      expect(object.name).to eq(new_name)
    end

    it "falls back to super" do
      expect { object.nothing = "Something" }.to raise_error(NoMethodError)
    end
  end
end
