require "sinatra/base"

class FakeService < Sinatra::Base
  protected

  def request_json
    request.body.rewind
    JSON.parse(request.body.read)
  end

  def json_response(status_code, json)
    content_type :json
    status status_code
    json
  end
end
