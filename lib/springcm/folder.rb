module Springcm
  class Folder
    def initialize(data, client)
      @client = client
      @data = data
    end

    def see?
      !!access_level.dig("See")
    end

    def read?
      !!access_level.dig("Read")
    end

    def write?
      !!access_level.dig("Write")
    end

    def move?
      !!access_level.dig("Move")
    end

    def create?
      !!access_level.dig("Create")
    end

    def set_access?
      !!access_level.dig("SetAccess")
    end

    def uid
      href[-36..-1]
    end

    def method_missing(m, *args, &block)
      key = m.to_s.split("_").map(&:capitalize).join
      if @data.key?(key)
        @data.fetch(key)
      else
        super
      end
    end
  end
end
