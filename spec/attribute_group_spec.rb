RSpec.describe Springcm::AttributeGroup do
  let(:client) { Springcm::Client.new(data_center, client_id, client_secret) }
  let(:account) { client.account }
  let(:all_attribute_groups) { account.all_attribute_groups }
  let(:attribute_group) { all_attribute_groups.first }

  before(:each) do
    client.connect!
  end

  it "returns attribute field" do
    expect(attribute_group.field("Field")).to be_a(Springcm::Attribute)
  end

  it "returns set attribute fields" do
    expect(attribute_group.set("Set")).to all(be_a(Springcm::Attribute))
  end
end
