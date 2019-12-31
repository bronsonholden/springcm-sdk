require "springcm-sdk/object"

module Springcm
  # A Resource is a SpringCM object that has an auto-assigned GUID.
  class Resource < Object
    # @return [String] The object's unique identifier (UID)
    def uid
      href[-36..-1]
    end

    # Resend a request to the API for this resource and return a new instance.
    def reload
      get
    end

    # Send a GET request for this resource.
    def get
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

    # Send a PATCH request for this resource.
    def patch
      conn = @client.authorized_connection(url: @client.object_api_url)
      res = conn.patch do |req|
        req.headers['Content-Type'] = "application/json"
        req.url resource_uri
        req.body = raw.to_json
      end
      if res.success?
        data = JSON.parse(res.body)
        self.class.new(data, @client)
      else
        nil
      end
    end

    # Send a PUT request for this resource.
    def put
      conn = @client.authorized_connection(url: @client.object_api_url)
      res = conn.put do |req|
        req.headers['Content-Type'] = "application/json"
        req.url resource_uri
        req.body = raw.to_json
      end
      if res.success?
        data = JSON.parse(res.body)
        self.class.new(data, @client)
      else
        nil
      end
    end

    # Send a DELETE request for this resource.
    def delete
      conn = @client.authorized_connection(url: @client.object_api_url)
      res = conn.delete do |req|
        req.url resource_uri
      end
      if res.success?
        data = JSON.parse(res.body)
        reload
      else
        nil
      end
    end

    # Retrieve the URI for this resource (relative to the base object API
    # URL).
    def resource_uri
      "#{resource_name}/#{uid}"
    end

    # Some resources have query parameters that must be passed when
    # retrieving it, e.g. expand=attributegroups when retrieving a document.
    def resource_params
      {}
    end

    # Pluralized resource name, e.g. documents or folders. Used to construct
    # request URLs.
    def resource_name
      "#{self.class.to_s.split("::").last.downcase}s"
    end
  end
end
