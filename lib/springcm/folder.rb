require "springcm/resource"
require "springcm/mixins/access_level"
require "springcm/mixins/parent_folder"
require "springcm/mixins/documents"

module Springcm
  class Folder < Resource
    include Springcm::AccessLevel
    include Springcm::ParentFolder
    include Springcm::Documents

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

    def documents
      uri = URI(documents_href)
      url = "#{uri.scheme}://#{uri.host}"
      conn = Faraday.new(url: url)
      conn.authorization('bearer', @client.access_token)
      res = conn.get do |req|
        req.url uri.path
      end
      if res.success?
        data = JSON.parse(res.body)
        items = data["Items"].map { |item|
          Document.new(item, @client)
        }
        items
      else
        nil
      end
    end
  end
end
