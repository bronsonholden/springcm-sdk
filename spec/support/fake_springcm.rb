require_relative "fake_service"

class FakeSpringcm < FakeService
  get "/folders" do
    if params["systemfolder"] == "root"
      builder = FolderBuilder.new(client).uid(UUID.generate)
      json_response 200, builder.data.to_json
    end
  end

  private

  def client
    Springcm::Client.new("uatna11", "client_id", "client_secret")
  end
end
