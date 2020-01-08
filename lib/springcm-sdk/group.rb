require "springcm-sdk/resource"
require "springcm-sdk/user"

module Springcm
  class Group < Resource
    # @return [ResourceList] Users that are a member of the specified Group.
    def users(offset: 0, limit: 20)
      Helpers.validate_offset_limit!(offset, limit)
      conn = @client.authorized_connection(url: @client.object_api_url)
      res = conn.get do |req|
        req.url "#{resource_uri}/groupmembers"
        req.params["offset"] = offset
        req.params["limit"] = limit
      end
      if res.success?
        data = JSON.parse(res.body)
        ResourceList.new(data, self, User, @client)
      else
        nil
      end
    end
  end
end
