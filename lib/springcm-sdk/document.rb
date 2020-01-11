require "springcm-sdk/resource"
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
