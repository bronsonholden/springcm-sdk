require_relative "fake_service"

class FakeSpringcmAuth < FakeService
  post "/" do
    data = request_json
    client_id = data.fetch("client_id")
    client_secret = data.fetch("client_secret")

    if client_id == "client_id" && client_secret == "client_secret"
      json_file_response 200, "auth_success.json"
    else
      json_file_response 401, "auth_invalid_client_id_or_secret.json"
    end
  end
end
