require "springcm-sdk/resource"
require "springcm-sdk/mixins/access_level"

module Springcm
  class Document < Resource
    include Springcm::AccessLevel

    def reload
      conn = @client.authorized_connection(url: @client.object_api_url)
      res = conn.get do |req|
        req.url resource_uri
        req.params["expand"] = "attributegroups"
      end
      if res.success?
        data = JSON.parse(res.body)
        Document.new(data, @client)
      else
        nil
      end
    end

    def delete
      conn = @client.authorized_connection(url: @client.object_api_url)
      res = conn.delete do |req|
        req.url resource_uri
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
