require_relative "fake_service"

class FakeSpringcm < FakeService
  get "/v201411/folders" do
    if params["systemfolder"] == "root"
      builder = FolderBuilder.new(client).uid(UUID.generate)
      json_response 200, builder.data.to_json
    end
  end

  get "/v201411/folders/:folder_uid/folders" do
    builder = PageBuilder.new(client)
    5.times do
      builder.add(FolderBuilder.new(client).uid(UUID.generate))
    end
    json_response 200, builder.build.to_json
  end

  private

  def client
    Springcm::Client.new("uatna11", "client_id", "client_secret")
  end
end
