require "securerandom"
require_relative "fake_service"

class FakeSpringcmAuth < FakeService
  post "/api/v201606/apiuser" do
    data = request_json
    client_id = data.fetch("client_id")
    client_secret = data.fetch("client_secret")

    if client_id == "client_id" && client_secret == "client_secret"
      json_response 200, {
          "access_token" => SecureRandom.uuid,
          "token_type": "bearer",
          "expires_in": 3600,
          "api_base_url": "https://apiuatna11.springcm.com"
      }.to_json
    else
      json_response 401, {
          "error" => "invalid_client",
          "errorDescription" => "Invalid Client Id or Client Secret"
      }.to_json
    end
  end
end
