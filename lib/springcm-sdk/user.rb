require "springcm-sdk/resource"
require "springcm-sdk/group"

module Springcm
  class User < Resource
    # @return [ResourceList] Groups that the specified User is a member of.
    def groups(offset: 0, limit: 20)
      Helpers.validate_offset_limit!(offset, limit)
      conn = @client.authorized_connection(url: @client.object_api_url)
      res = conn.get do |req|
        req.url "#{resource_uri}/groups"
        req.params["offset"] = offset
        req.params["limit"] = limit
      end
      if res.success?
        data = JSON.parse(res.body)
        ResourceList.new(data, self, Group, @client)
      else
        nil
      end
    end
  end
end
