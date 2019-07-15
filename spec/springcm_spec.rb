RSpec.describe Springcm do
  it "has a version number" do
    expect(Springcm::VERSION).not_to be nil
  end

  describe Springcm::Client do
    def self.test_data_center(data_center)
      context data_center do
        let(:data_center) { data_center }
        it "successfully creates client" do
          expect { client }.not_to raise_error
        end
      end
    end

    let(:client_id) { "client_id" }
    let(:client_secret) { "client_secret" }
    let(:client) { Springcm::Client.new(data_center: data_center, client_id: client_id, client_secret: client_secret) }

    test_data_center "uatna11"
    test_data_center "na11"
  end
end
