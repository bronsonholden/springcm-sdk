require "springcm-sdk/resource"
require "springcm-sdk/applied_attribute_group"
require "springcm-sdk/mixins/access_level"
require "springcm-sdk/mixins/attributes"
require "springcm-sdk/mixins/parent_folder"
require "springcm-sdk/history_item"

module Springcm
  class Document < Resource
    include Springcm::Mixins::AccessLevel
    include Springcm::Mixins::ParentFolder
    include Springcm::Mixins::Attributes

    def self.resource_params
      {
        "expand" => "attributegroups,path"
      }
    end

    def download
      io = StringIO.new
      conn = @client.authorized_connection(url: @client.download_api_url)
      res = conn.get do |req|
        req.url resource_uri
        req.options.on_data = Proc.new do |chunk, total_bytes|
          io << chunk
        end
      end
      if res.success?
        io.rewind
        io
      else
        nil
      end
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

    def versions(offset: 0, limit: 20)
      Helpers.validate_offset_limit!(offset, limit)
      conn = @client.authorized_connection(url: @client.object_api_url)
      res = conn.get do |req|
        req.url "#{resource_uri}/versions"
        req.params["offset"] = offset
        req.params["limit"] = limit
      end
      if res.success?
        data = JSON.parse(res.body)
        ResourceList.new(data, self, Document, @client, method_override: :versions)
      else
        nil
      end
    end

    def upload_version(file:, type: :binary)
      # TODO: DRY Folder#upload
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
        req.headers["Content-Disposition"] = "attachment; filename=\"#{name}\""
        req.url "documents/#{uid}"
        req.body = file
      end
      if res.success?
        data = JSON.parse(res.body)
        Document.new(data, @client)
      else
        nil
      end
    end

    # Copy a document to the given folder. You must specify one of: path,
    # uid.
    # @param path [String] Destination folder path
    # @param uid [String] Destination folder UID
    # @raise [ArgumentError]
    def copy(path: nil, uid: nil)
      parent = @client.folder(path: path, uid: uid)
      body = {
        "DestinationFolder" => parent.raw,
        "DocumentsToCopy" => [ raw ]
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

    # Delete a document without checking if not already trash. Deletion via
    # the API is not idempotent—if you delete a document that is in the
    # trash, it is permanently deleted. To permanently delete a document,
    # you must use this method.
    def delete!
      unsafe_delete
    end

    # Alias delete method inherited by resource
    alias_method :unsafe_delete, :delete
    private :unsafe_delete

    # Safely delete a document. If the document is in the trash, it will
    # not be deleted.
    def delete
      reload!
      if path.start_with?("/#{@client.account.name}/Trash")
        raise Springcm::DeleteRefusedError.new(path)
      end
      unsafe_delete
    end
  end
end
