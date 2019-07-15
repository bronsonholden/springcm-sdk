require "sinatra/base"

class FakeService < Sinatra::Base
  protected

  def request_json
    request.body.rewind
    JSON.parse(request.body.read)
  end

  def json_response(status_code, file_name=nil)
    content_type :json
    status status_code
    if file_name
      File.open(File.dirname(__FILE__) + "/../fixtures/" + file_name, "rb").read
    else
      ""
    end
  end
end
