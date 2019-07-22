module Springcm
  class Object
    def initialize(data, client)
      @client = client
      @data = data
    end

    # @return [String] The folder unique identifier (UID)
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
