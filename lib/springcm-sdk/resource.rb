require "springcm-sdk/object"

module Springcm
  class Resource < Object
    # @return [String] The folder unique identifier (UID)
    def uid
      href[-36..-1]
    end
  end
end
