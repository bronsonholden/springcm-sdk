require "springcm/object"
require "springcm/access_level"
require "springcm/parent_folder"

module Springcm
  class Folder < Object
    include Springcm::AccessLevel
    include Springcm::ParentFolder

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
        nil
      end
    end

    def parent_folder
      uri = URI(parent_folder_href)
      url = "#{uri.scheme}://#{uri.host}"
      conn = Faraday.new(url: url)
      conn.authorization('bearer', @client.access_token)
      res = conn.get do |req|
        req.url uri.path
      end
      if res.success?
        data = JSON.parse(res.body)
        Folder.new(data, @client)
      else
        nil
      end
    end
  end
end
