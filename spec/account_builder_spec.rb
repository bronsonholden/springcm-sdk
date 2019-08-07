RSpec.describe AccountBuilder do
  let(:client) { Springcm::Client.new(data_center, client_id, client_secret) }
  let(:builder) { AccountBuilder.new(client) }
  let(:account) { builder.build }

  it "rejects non-String account IDs" do
    expect { builder.id(0) }.to raise_error(ArgumentError)
  end

  it "rejects invalid account IDs" do
    expect { builder.id("0") }.to raise_error(ArgumentError)
  end

  it "sets account ID" do
    builder.id("10")
    expect(account.id).to eq("10")
  end

  it "rejects invalid account names" do
    expect { builder.name(123) }.to raise_error(ArgumentError)
  end

  it "sets account name" do
    builder.name("ACME, Inc")
    expect(account.name).to eq("ACME, Inc")
  end
end
