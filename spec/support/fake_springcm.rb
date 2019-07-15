require_relative "fake_service"

class FakeSpringcm < FakeService
  get "/" do
    json_response 200
  end
end
