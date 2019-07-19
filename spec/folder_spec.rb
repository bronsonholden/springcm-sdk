RSpec.describe Springcm::Folder do
  let(:client) { Springcm::Client.new("uatna11", "client_id", "client_secret") }
  let(:data) { JSON.parse(File.open(File.dirname(__FILE__) + "/fixtures/root_folder.json", "rb").read) }
  let(:folder) { Springcm::Folder.new(data, client) }

  def self.test_valid_attribute(m, expected_value=nil)
    it "#{m.to_s} is retrieved" do
      value = folder.send(m)
      if !expected_value.nil?
        expect(value).to eq(expected_value)
      else
        expect(value).not_to be_nil
      end
    end
  end

  context "attribute methods" do
    it "falls back to method_missing" do
      expect { folder.not_an_attribute_or_method }.to raise_error(NoMethodError)
    end

    test_valid_attribute :name, "Fake SpringCM Account"
    test_valid_attribute :created_date
    test_valid_attribute :created_by
    test_valid_attribute :updated_date
    test_valid_attribute :updated_by
    test_valid_attribute :description
    test_valid_attribute :browse_documents_url
  end
end
