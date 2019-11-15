require "springcm-sdk/resource"
require "springcm-sdk/resource_list"
require "springcm-sdk/mixins/access_level"
require "springcm-sdk/mixins/parent_folder"
require "springcm-sdk/mixins/documents"
require "springcm-sdk/helpers"

module Springcm
  class Folder < Resource
    include Springcm::AccessLevel
    include Springcm::ParentFolder
    include Springcm::Documents

    def folders(offset: 0, limit: 20)
      Helpers.validate_offset_limit!(offset, limit)
      conn = @client.authorized_connection(url: @client.object_api_url)
      res = conn.get do |req|
        req.url "folders/#{uid}/folders"
        req.params["offset"] = offset
        req.params["limit"] = limit
      end
      if res.success?
        data = JSON.parse(res.body)
        ResourceList.new(data, self, Folder, @client)
      else
        nil
      end
    end

    def parent_folder
      uri = URI(parent_folder_href)
      url = "#{uri.scheme}://#{uri.host}"
      conn = @client.authorized_connection(url: url)
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

    def documents(offset: 0, limit: 20)
      Helpers.validate_offset_limit!(offset, limit)
      uri = URI(documents_href)
      url = "#{uri.scheme}://#{uri.host}"
      conn = @client.authorized_connection(url: url)
      res = conn.get do |req|
        req.url uri.path
        req.params["offset"] = offset
        req.params["limit"] = limit
      end
      if res.success?
        data = JSON.parse(res.body)
        ResourceList.new(data, self, Document, @client)
      else
        nil
      end
    end

    def delete
      conn = @client.authorized_connection(url: @client.object_api_url)
      res = conn.delete do |req|
        req.url "folders/#{uid}"
      end
      if res.success?
        data = JSON.parse(res.body)
        self
      else
        nil
      end
    end
  end
end
