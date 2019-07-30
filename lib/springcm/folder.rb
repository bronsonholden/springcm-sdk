require "springcm/object"
require "springcm/access_level"

module Springcm
  class Folder < Object
    include Springcm::AccessLevel

    def folders
      conn = Faraday.new(url: @client.object_api_url)
      conn.authorization('bearer', @client.access_token)
      res = conn.get do |req|
        req.url "folders/#{uid}/folders"
      end
      if res.success?
        data = JSON.parse(res.body)
        items = data["Items"].map { |item|
          Folder.new(item, @client)
        }
        items
      else
        puts res.inspect
        nil
      end
    end
  end
end
