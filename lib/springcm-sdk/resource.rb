require "springcm-sdk/object"

module Springcm
  class Resource < Object
    # @return [String] The folder unique identifier (UID)
    def uid
      href[-36..-1]
    end

    def reload
      conn = @client.authorized_connection(url: @client.object_api_url)
      res = conn.get do |req|
        req.url resource_uri
        resource_params.each { |key, value|
          req.params[key] = value
        }
      end
      if res.success?
        data = JSON.parse(res.body)
        self.class.new(data, @client)
      else
        nil
      end
    end

    def resource_uri
      "#{resource_name}/#{uid}"
    end

    def resource_params
      {}
    end

    def resource_name
      "#{self.class.to_s.split("::").last.downcase}s"
    end
  end
end
