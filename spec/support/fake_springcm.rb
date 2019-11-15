require_relative "fake_service"

class FakeSpringcm < FakeService
  def initialize
    @root_uid = UUID.generate
    super
  end

  get "/v201411/accounts/current" do
    builder = AccountBuilder.new(client)
    json_response 200, builder.data.to_json
  end

  get "/v201411/folders" do
    if params["systemfolder"] == "root" || params["path"] == "/"
      builder = FolderBuilder.new(client).uid(@root_uid)
      json_response 200, builder.data.to_json
    elsif !params["path"].nil?
      builder = FolderBuilder.new(client).uid(UUID.generate)
      builder.name(params["path"].split("/").last)
      json_response 200, builder.data.to_json
    else
      # Stub the validation errors
      json_response 422, {
        "Error" => {},
        "ValidationErrors" => []
      }
    end
  end

  get "/v201411/folders/:folder_uid" do
    builder = FolderBuilder.new(client).uid(params[:folder_uid])
    json_response 200, builder.data.to_json
  end

  delete "/v201411/folders/:folder_uid" do
    builder = FolderBuilder.new(client).uid(params[:folder_uid])
    json_response 200, builder.data.to_json
  end

  get "/v201411/folders/:folder_uid/folders" do
    parent_folder = FolderBuilder.new(client).uid(params["folder_uid"]).build
    builder = PageBuilder.new(parent_folder, Springcm::Folder, client).offset(params.fetch(:offset, 0).to_i).limit(params.fetch(:limit, 20).to_i)
    parent = FolderBuilder.new(client).build
    50.times do
      folder = FolderBuilder.new(client).uid(UUID.generate).parent(parent)
      builder.add(folder)
    end
    json_response 200, builder.build.to_json
  end

  get "/v201411/folders/:folder_uid/documents" do
    parent_folder = FolderBuilder.new(client).uid(params["folder_uid"]).build
    builder = PageBuilder.new(parent_folder, Springcm::Document, client)
    folder = FolderBuilder.new(client).build
    5.times do
      document = DocumentBuilder.new(client).uid(UUID.generate).parent(folder)
      builder.add(document)
    end
    json_response 200, builder.build.to_json
  end

  get "/v201411/documents" do
    if !params["path"].nil?
      builder = DocumentBuilder.new(client).name(File.basename(params["path"]))
      json_response 200, builder.data.to_json
    else
      # SpringCM returns 404 instead of a validation error. Weird.
      json_response 404, {
        "Message" => "No HTTP resource was found that matches the request URI '#{request.url}'"
      }
    end
  end

  get "/v201411/documents/:document_uid" do
    builder = DocumentBuilder.new(client).uid(params[:document_uid])
    json_response 200, builder.data.to_json
  end

  delete "/v201411/documents/:document_uid" do
    builder = DocumentBuilder.new(client).uid(params[:document_uid])
    json_response 200, builder.data.to_json
  end

  private

  def client
    Springcm::Client.new("uatna11", "client_id", "client_secret")
  end
end
