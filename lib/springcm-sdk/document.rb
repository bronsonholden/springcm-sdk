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
        puts res.body
      end
    end

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

    def delete!
      unsafe_delete
    end

    alias_method :unsafe_delete, :delete
    private :unsafe_delete

    def delete
      reload!
      if path.start_with?("/#{@client.account.name}/Trash")
        raise Springcm::DeleteRefusedError.new(path)
      end
      unsafe_delete
    end
  end
end
