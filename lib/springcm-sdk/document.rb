require "springcm-sdk/resource"
require "springcm-sdk/mixins/access_level"
require "springcm-sdk/mixins/attributes"
require "springcm-sdk/history_item"

module Springcm
  class Document < Resource
    include Springcm::Mixins::AccessLevel
    include Springcm::Mixins::ParentFolder
    include Springcm::Mixins::Attributes

    def self.resource_params
      {
        "expand" => "attributegroups"
      }
    end

    def history(offset: 0, limit: 20)
      Helpers.validate_offset_limit!(offset, limit)
      conn = @client.authorized_connection(url: @client.object_api_url)
      res = conn.get do |req|
        req.url "#{resource_uri}/historyitems"
        req.params["offset"] = offset
        req.params["limit"] = limit
      end
      if res.success?
        data = JSON.parse(res.body)
        ResourceList.new(data, self, HistoryItem, @client)
      else
        nil
      end
    end
  end
end
