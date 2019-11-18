require "springcm-sdk/resource"
require "springcm-sdk/mixins/access_level"

module Springcm
  class Document < Resource
    include Springcm::AccessLevel

    def self.resource_params
      {
        "expand" => "attributegroups"
      }
    end

    def delete
      conn = @client.authorized_connection(url: @client.object_api_url)
      res = conn.delete do |req|
        req.url resource_uri
      end
      if res.success?
        data = JSON.parse(res.body)
        reload
      else
        nil
      end
    end
  end
end
