RSpec.describe PageBuilder do
  let(:client) { Springcm::Client.new("uatna11", "client_id", "client_secret") }
  let(:builder) { PageBuilder.new(client).href("") }
  let(:paged) { builder.build }

  def self.test_invalid_property(prop, bad_value, description: nil)
    description ||= bad_value.inspect
    it "rejects #{description} #{prop.to_s}" do
      expect { builder.send(prop, bad_value) }.to raise_error(ArgumentError)
    end
  end

  test_invalid_property :limit, 0, description: "zero"
  test_invalid_property :limit, -1, description: "negative"
  test_invalid_property :limit, "0", description: "non-Integer"
  test_invalid_property :offset, -1, description: "negative"
  test_invalid_property :offset, "0", description: "non-Integer"

  it "sets limit" do
    builder.limit(5)
    expect(paged["Limit"]).to eq(5)
  end

  it "sets offset" do
    builder.offset(10)
    expect(paged["Offset"]).to eq(10)
  end

  context "with folder" do
    it "creates complete page" do
      n = 20
      n.times { builder.add(FolderBuilder.new(client).uid(UUID.generate)) }
      expect(paged["Items"].size).to eq(n)
      # TODO: Test Href excludes paging params
    end

    it "creates partial page" do
      builder.add(FolderBuilder.new(client).uid(UUID.generate))
      expect(paged["Items"].size).to eq(1)
      # TODO: Test Href includes paging params
    end
  end
end
