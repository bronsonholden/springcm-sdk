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

  def json_file_response(status_code, file_name=nil)
    json_response status_code, File.open(File.dirname(__FILE__) + "/../fixtures/" + file_name, "rb").read
  end
end
