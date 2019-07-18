RSpec.describe Springcm::Error do
  let(:exception) { Springcm::Error.new('Test exception') }
  it "reports on inspection" do
    expect(exception.inspect).to match(/Test exception/)
  end
end
