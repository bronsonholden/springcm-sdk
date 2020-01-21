require "uuid"
require_relative "fake_service"

# Mock SpringCM Content API service.
class FakeSpringcmContent < FakeService
  get "/v201411/documents/:document_uid" do
    "content"
  end
end
