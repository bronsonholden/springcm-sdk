RSpec.describe DocumentBuilder do
  let(:client) { Springcm::Client.new("uatna11", "client_id", "client_secret") }
  let(:uid) { UUID.generate }
  let(:document_name) { "Test Document.pdf" }
  let(:login_name) { "johndoe@email.com" }
  let(:description) { "A test document" }
  let(:builder) { DocumentBuilder.new(client).uid(uid) }
  let(:document) { builder.build }

  it "rejects invalid UIDs" do
    expect { builder.uid("not-a-uuid") }.to raise_error(ArgumentError)
  end

  it "created_date format is correct" do
    expect(document.created_date).to eq("2000-01-01T00:00:00.000Z")
  end

  it "updated_date format is correct" do
    expect(document.created_date).to eq("2000-01-01T00:00:00.000Z")
  end

  it "sets UID" do
    expect(document.uid).to eq(uid)
  end

  it "sets name" do
    builder.name(document_name)
    expect(document.name).to eq(document_name)
  end

  it "sets created_date" do
    now = Time.now
    builder.created_date(now)
    expect(document.created_date).to eq(now.strftime("%FT%T.%3NZ"))
  end

  it "sets updated_date" do
    now = Time.now
    builder.updated_date(now)
    expect(document.updated_date).to eq(now.strftime("%FT%T.%3NZ"))
  end

  it "sets created_by" do
    builder.created_by(login_name)
    expect(document.created_by).to eq(login_name)
  end

  it "sets updated_by" do
    builder.updated_by(login_name)
    expect(document.updated_by).to eq(login_name)
  end

  it "sets description" do
    builder.description(description)
    expect(document.description).to eq(description)
  end

  it "sets access" do
    builder.access(:see, :read)
    expect(document.see?).to eq(true)
    expect(document.read?).to eq(true)
    expect(document.write?).to eq(false)
    expect(document.move?).to eq(false)
    expect(document.create?).to eq(false)
    expect(document.set_access?).to eq(false)
  end

  it "disallows invalid access settings" do
    expect { builder.access(:barrel_roll) }.to raise_error(ArgumentError)
  end

  it "sets file size" do
    builder.file_size(5)
    expect(document.pdf_file_size).to eq(5)
    expect(document.native_file_size).to eq(5)
  end

  it "disallows invalid page count" do
    expect { builder.page_count("page count") }.to raise_error(ArgumentError)
  end

  it "disallows invalid file size" do
    expect { builder.file_size("file size") }.to raise_error(ArgumentError)
  end
end
