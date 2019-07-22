require "springcm/object"

module Springcm
  class Folder < Object
    # @return [Boolean] Does the API user have see permission
    def see?
      !!access_level.dig("See")
    end

    # @return [Boolean] Does the API user have read permission
    def read?
      !!access_level.dig("Read")
    end

    # @return [Boolean] Does the API user have write permission
    def write?
      !!access_level.dig("Write")
    end

    # @return [Boolean] Does the API user have move permission
    def move?
      !!access_level.dig("Move")
    end

    # @return [Boolean] Does the API user have create permission
    def create?
      !!access_level.dig("Create")
    end

    # @return [Boolean] Does the API user have set access permission
    def set_access?
      !!access_level.dig("SetAccess")
    end

    # @return [String] The folder unique identifier (UID)
    def uid
      href[-36..-1]
    end
  end
end
