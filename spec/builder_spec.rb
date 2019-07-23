RSpec.describe Builder do
  class ExampleBuilder < Builder
    property :a_string, default: "String"
  end

  let(:builder) { ExampleBuilder.new(nil) }

  it "disallows invalid property types" do
    expect { builder.a_string(1) }.to raise_error(ArgumentError)
  end
end
