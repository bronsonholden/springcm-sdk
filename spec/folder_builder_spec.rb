RSpec.describe FolderBuilder do
  let(:client) { Springcm::Client.new("uatna11", "client_id", "client_secret") }
  let(:uid) { UUID.generate }
  let(:folder_name) { "My Folder" }
  let(:login_name) { "johndoe@email.com" }
  let(:builder) { FolderBuilder.new(client).uid(uid) }
  let(:folder) { builder.build }

  it "rejects invalid UIDs" do
    expect { builder.uid("not-a-uuid") }.to raise_error(ArgumentError)
  end

  it "created_date format is correct" do
    expect(folder.created_date).to eq("2000-01-01T00:00:00.000Z")
  end

  it "updated_date format is correct" do
    expect(folder.created_date).to eq("2000-01-01T00:00:00.000Z")
  end

  it "sets UID" do
    expect(folder.uid).to eq(uid)
  end

  it "sets name" do
    builder.name(folder_name)
    expect(folder.name).to eq(folder_name)
  end

  it "sets created_date" do
    now = Time.now
    builder.created_date(now)
    expect(folder.created_date).to eq(now.strftime("%FT%T.%3NZ"))
  end

  it "sets updated_date" do
    now = Time.now
    builder.updated_date(now)
    expect(folder.updated_date).to eq(now.strftime("%FT%T.%3NZ"))
  end

  it "sets created_by" do
    builder.created_by(login_name)
    expect(folder.created_by).to eq(login_name)
  end

  it "sets updated_by" do
    builder.updated_by(login_name)
    expect(folder.updated_by).to eq(login_name)
  end
end
