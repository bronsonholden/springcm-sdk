RSpec.describe Springcm::Folder do
  let(:client) { Springcm::Client.new(data_center, client_id, client_secret) }
  let(:folder) { client.root_folder }
  let(:folder_list) { client.root_folder.folders }
  let(:next_list) { folder_list.next }
  let(:prev_list) { next_list.prev }
  let(:first_list) { folder_list.first }
  let(:last_list) { folder_list.last }
  let(:garbo) { client.folder(uid: "a8765e66-280a-ea11-b808-48df378a7098") }
  let(:group) { client.groups.items.first.get }

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
    before(:each) do
      client.connect!
    end

    it "falls back to method_missing" do
      expect { folder.not_an_attribute_or_method }.to raise_error(NoMethodError)
    end

    test_valid_attribute :name, "Folder"
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

    it "can be reloaded" do
      expect(folder.reload).to be_a(Springcm::Folder)
    end

    it "can be deleted" do
      expect(garbo.delete).to be_a(Springcm::Folder)
    end

    it "can be moved" do
      expect(garbo.move(path: "/")).to be_a(Springcm::Folder)
    end

    it "has attributes" do
      expect(folder.attribute_groups).to be_a(Hash)
    end

    it "generates subfolder list" do
      expect(folder_list).to be_a(Springcm::ResourceList)
    end

    it "retrieves subfolders" do
      expect(folder_list.items).to all(be_a(Springcm::Folder))
    end

    it "retrieves requested set size" do
      expect(client.root_folder.folders(limit: 5).items.size).to eq(5)
    end

    it "provides total item count" do
      expect(folder_list.total).to be_a(Integer)
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

    describe "security" do
      it "rejects invalid access" do
        expect { folder.update_security(group: group, access: :fake_access) }.to raise_error(ArgumentError)
      end

      it "rejects invalid groups" do
        expect { folder.update_security(group: 0, access: :view) }.to raise_error(ArgumentError)
      end

      it "sets access" do
        expect(folder.update_security(group: group, access: :view)).to be_a(Springcm::ChangeSecurityTask)
      end
    end
  end
end
