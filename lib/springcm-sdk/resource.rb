require "springcm-sdk/object"

module Springcm
  class Resource < Object
    # @return [String] The folder unique identifier (UID)
    def uid
      href[-36..-1]
    end

    def resource_uri
      "#{resource_name}/#{uid}"
    end

    def resource_name
      "#{self.class.to_s.split("::").last.downcase}s"
    end
  end
end
