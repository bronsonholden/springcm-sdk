RSpec.describe Springcm::User do
  let(:client) { Springcm::Client.new(data_center, client_id, client_secret) }
  let(:users) { client.users }
  let(:user) { users.items.first.get }

  it "returns list of users" do
    expect(users.items).to all(be_a(Springcm::User))
  end

  it "returns group membership" do
    expect(user.groups.items).to all(be_a(Springcm::Group))
  end
end
