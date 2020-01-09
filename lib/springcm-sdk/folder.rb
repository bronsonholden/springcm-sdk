require "springcm-sdk/resource"
require "springcm-sdk/resource_list"
require "springcm-sdk/change_security_task"
require "springcm-sdk/mixins/access_level"
require "springcm-sdk/mixins/parent_folder"
require "springcm-sdk/mixins/documents"
require "springcm-sdk/helpers"

module Springcm
  class Folder < Resource
    include Springcm::Mixins::AccessLevel
    include Springcm::Mixins::ParentFolder
    include Springcm::Mixins::Documents

    def self.resource_params
      {
        "expand" => "attributegroups,path"
      }
    end

    # Retrieve a page of folders contained in this folder.
    def folders(offset: 0, limit: 20)
      Helpers.validate_offset_limit!(offset, limit)
      conn = @client.authorized_connection(url: @client.object_api_url)
      res = conn.get do |req|
        req.url "#{resource_uri}/folders"
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

    # Retrieve the containing folder.
    def parent_folder
      uri = URI(parent_folder_href)
      url = "#{uri.scheme}://#{uri.host}"
      conn = @client.authorized_connection(url: url)
      res = conn.get do |req|
        req.url uri.path
        resource_params.each { |key, value|
          req.params[key] = value
        }
      end
      if res.success?
        data = JSON.parse(res.body)
        Folder.new(data, @client)
      else
        nil
      end
    end

    # Retrieve a page of documents in this folder.
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

    def update_security(group:, access:)
      Helpers.validate_access!(access)
      if !group.is_a?(Springcm::Group)
        raise ArgumentError.new("Invalid group; must be a Springcm::Group")
      end
      conn = @client.authorized_connection(url: @client.object_api_url)
      res = conn.post do |req|
        req.headers["Content-Type"] = "application/json"
        req.url "changesecuritytasks"
        req.body = {
          "Status" => "",
          "Security" => {
            "Groups" => [
              {
                "Item" => group.raw,
                "AccessType" => access.to_s.split('_').map(&:capitalize).join
              }
            ]
          },
          "Folder" => raw
        }.to_json
      end
      if res.success?
        data = JSON.parse(res.body)
        ChangeSecurityTask.new(data, @client)
      else
        puts res.body
        nil
      end
    end
  end
end
