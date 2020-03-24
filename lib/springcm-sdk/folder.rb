require "springcm-sdk/resource"
require "springcm-sdk/document"
require "springcm-sdk/resource_list"
require "springcm-sdk/change_security_task"
require "springcm-sdk/copy_task"
require "springcm-sdk/mixins/access_level"
require "springcm-sdk/mixins/parent_folder"
require "springcm-sdk/mixins/documents"
require "springcm-sdk/helpers"
require "uri"

module Springcm
  class Folder < Resource
    include Springcm::Mixins::AccessLevel
    include Springcm::Mixins::ParentFolder
    include Springcm::Mixins::Documents
    include Springcm::Mixins::Attributes

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

    def upload(name:, file:, type: :binary)
      # TODO: DRY Document#upload_version
      file_types = {
        binary: "application/octet-stream",
        pdf: "application/pdf",
        csv: "text/csv",
        txt: "text/plain"
      }
      if !type.nil? && !file_types.keys.include?(type)
        raise ArgumentError.new("File type must be one of: nil, #{file_types.map(&:inspect).join(", ")}")
      end
      conn = @client.authorized_connection(url: @client.upload_api_url)
      res = conn.post do |req|
        req.headers["Content-Type"] = file_types[type]
        req.headers["Content-Length"] = file.size.to_s
        req.url "folders/#{uid}/documents?name=#{URI.escape(name)}"
        req.body = file
      end
      if res.success?
        data = JSON.parse(res.body)
        Document.new(data, @client)
      else
        nil
      end
    end

    # access
    # InheritFromParentFolder, NoAccess, View, ViewCreate, ViewEdit, ViewEditDelete, ViewEditDeleteSetAccess
    def update_security(group:, access:)
      Helpers.validate_access!(access)
      if !group.is_a?(Springcm::Group)
        raise ArgumentError.new("Invalid group; must be a Springcm::Group")
      end
      if group.group_type != "Security"
        raise ArgumentError.new("Invalid group type; must be a security group")
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
        nil
      end
    end

    def create_folder(name:)
      conn = @client.authorized_connection(url: @client.object_api_url)
      res = conn.post do |req|
        req.headers["Content-Type"] = "application/json"
        req.url "folders"
        req.body = {
          "ParentFolder" => raw,
          "Name" => name
        }.to_json
      end
      if res.success?
        data = JSON.parse(res.body)
        Folder.new(data, @client)
      else
        nil
      end
    end

    def copy(path: nil, uid: nil)
      parent = @client.folder(path: path, uid: uid)
      body = {
        "DestinationFolder" => parent.raw,
        "FoldersToCopy" => [ raw ]
      }
      conn = @client.authorized_connection(url: @client.object_api_url)
      res = conn.post do |req|
        req.headers["Content-Type"] = "application/json"
        req.url "copytasks"
        req.body = body.to_json
      end
      if res.success?
        data = JSON.parse(res.body)
        CopyTask.new(data, @client)
      else
        nil
      end
    end
  end
end
