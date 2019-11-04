RSpec.describe Springcm::Folder do
  let(:client) { Springcm::Client.new(data_center, client_id, client_secret) }
  let(:data) { JSON.parse(File.open(File.dirname(__FILE__) + "/fixtures/root_folder.json", "rb").read) }
  let(:folder) { Springcm::Folder.new(data, client) }
  let(:folder_list) { client.root_folder.folders }
  let(:next_list) { folder_list.next }
  let(:prev_list) { next_list.prev }
  let(:first_list) { folder_list.first }
  let(:last_list) { folder_list.last }

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
    test_valid_attribute :see?, true
    test_valid_attribute :read?, true
    test_valid_attribute :write?, true
    test_valid_attribute :move?, true
    test_valid_attribute :create?, true
    test_valid_attribute :set_access?, true
  end

  context "folder API" do
    before(:each) do
      client.connect!
    end

    it "generates subfolder list" do
      expect(folder_list).to be_a(Springcm::ResourceList)
    end

    it "retrieves subfolders" do
      expect(folder_list.items).to all(be_a(Springcm::Folder))
    end

    it "retrieves parent folder" do
      expect(folder_list.items.first.parent_folder).to be_a(Springcm::Folder)
    end

    it "retrieves next set" do
      expect(next_list).to be_a(Springcm::ResourceList)
    end

    it "retrieves next set of folders" do
      expect(next_list.items).to all(be_a(Springcm::Folder))
    end

    it "retrieves empty previous set" do
      expect(folder_list.prev).to be_nil
    end

    it "retrieves previous set" do
      expect(prev_list).to be_a(Springcm::ResourceList)
    end

    it "retrieves previous set of folders" do
      expect(prev_list.items).to all(be_a(Springcm::Folder))
    end

    it "retrieves first set" do
      expect(first_list).to be_a(Springcm::ResourceList)
    end

    it "retrieves first set of folders" do
      expect(first_list.items).to all(be_a(Springcm::Folder))
    end

    it "retrieves last set" do
      expect(last_list).to be_a(Springcm::ResourceList)
    end

    it "retrieves last set of folders" do
      expect(last_list.items).to all(be_a(Springcm::Folder))
    end
  end
end
