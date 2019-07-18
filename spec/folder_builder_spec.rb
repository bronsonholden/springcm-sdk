RSpec.describe FolderBuilder do
  let(:client) { Springcm::Client.new(data_center: 'uatna11', client_id: 'client_id', client_secret: 'client_secret') }
  let(:uid) { UUID.generate }
  let(:folder_name) { "My Folder" }
  let(:builder) { FolderBuilder.new(client).uid(uid) }
  let(:folder) { builder.build }

  it "rejects invalid UIDs" do
    expect { builder.uid("not-a-uuid") }.to raise_error(ArgumentError)
  end

  it "sets UID" do
    expect(folder.uid).to eq(uid)
  end

  it "sets name" do
    builder.name(folder_name)
    expect(folder.name).to eq(folder_name)
  end
end
