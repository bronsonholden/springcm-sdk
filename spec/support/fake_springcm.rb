require_relative "fake_service"

class FakeSpringcm < FakeService
  get "/v201411/accounts/current" do
    builder = AccountBuilder.new(client)
    json_response 200, builder.data.to_json
  end

  get "/v201411/folders" do
    if params["systemfolder"] == "root"
      builder = FolderBuilder.new(client).uid(UUID.generate)
      json_response 200, builder.data.to_json
    elsif !params["path"].nil?
      builder = FolderBuilder.new(client).uid(UUID.generate)
      builder.name(params["path"].split("/").last)
      json_response 200, builder.data.to_json
    end
  end

  get "/v201411/folders/:folder_uid" do
    builder = FolderBuilder.new(client).uid(params[:folder_uid])
    json_response 200, builder.data.to_json
  end

  get "/v201411/folders/:folder_uid/folders" do
    builder = PageBuilder.new(client)
    parent = FolderBuilder.new(client).build
    50.times do
      folder = FolderBuilder.new(client).uid(UUID.generate).parent(parent)
      builder.add(folder)
    end
    json_response 200, builder.build.to_json
  end

  get "/v201411/folders/:folder_uid/documents" do
    builder = PageBuilder.new(client)
    folder = FolderBuilder.new(client).build
    5.times do
      document = DocumentBuilder.new(client).uid(UUID.generate).parent(folder)
      builder.add(document)
    end
    json_response 200, builder.build.to_json
  end

  private

  def client
    Springcm::Client.new("uatna11", "client_id", "client_secret")
  end
end
