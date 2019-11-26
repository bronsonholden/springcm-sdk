module Springcm
  module Mixins
    # Mixin for objects that have a parent folder.
    module ParentFolder
      def parent_folder_href
        # Root folders won't have ParentFolder key
        @data.dig("ParentFolder", "Href")
      end

      def move(path: nil, uid: nil)
        parent = @client.folder(path: path, uid: uid)
        body = {
          "ParentFolder" => parent.raw
        }
        conn = @client.authorized_connection(url: @client.object_api_url)
        res = conn.patch do |req|
          req.headers["Content-Type"] = "application/json"
          req.url resource_uri
          req.body = body.to_json
        end
        if res.success?
          data = JSON.parse(res.body)
          self.class.new(data, @client)
        else
          nil
        end
      end
    end
  end
end
