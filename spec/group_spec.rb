RSpec.describe Springcm::Group do
  let(:client) { Springcm::Client.new(data_center, client_id, client_secret) }
  let(:groups) { client.groups }
  let(:group) { groups.items.first.get }

  it "returns list of groups" do
    expect(groups.items).to all(be_a(Springcm::Group))
  end

  it "returns group members" do
    expect(group.users.items).to all(be_a(Springcm::User))
  end
end
