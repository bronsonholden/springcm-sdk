require_relative "fake_service"

class FakeSpringcm < FakeService
  get "/folders" do
    if params["systemfolder"] == "root"
      json_file_response 200, "root_folder.json"
    end
  end
end
