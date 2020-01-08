require "springcm-sdk/object"
require "springcm-sdk/attribute_group"

module Springcm
  class Account < Object
    def initialize(data, client)
      super(data, client)
      @all_attribute_groups = nil
    end

    # Retrieve all attribute groups for this account. Calls #attribute_groups
    # and concatenates results to a cache that is returned from future calls
    # to #all_attribute_groups.
    def all_attribute_groups
      if @all_attribute_groups.nil?
        load_all_attribute_groups
      end
      @all_attribute_groups
    end

    # Retrieve a page of attribute groups in this account. In most cases,
    # you can call #all_attribute_groups instead, as attribute group
    # configurations do not frequently change.
    def attribute_groups(offset: 0, limit: 20)
      Helpers.validate_offset_limit!(offset, limit)
      conn = @client.authorized_connection(url: @client.object_api_url)
      res = conn.get do |req|
        req.url "accounts/current/attributegroups"
        req.params["offset"] = offset
        req.params["limit"] = limit
      end
      if res.success?
        data = JSON.parse(res.body)
        ResourceList.new(data, self, AttributeGroup, @client)
      else
        nil
      end
    end

    private

    def load_all_attribute_groups
      @all_attribute_groups = []
      list = attribute_groups(offset: 0, limit: 20)
      while !list.nil?
        @all_attribute_groups.concat(list.items)
        list = list.next
      end
    end
  end
end
