require "springcm/version"
require "springcm/client"

module Springcm
  class Error < StandardError
    def initialize(exception)
      @exception = exception
    end

    def inspect
      %(#<#{self.class} @exception=#{@exception}>)
    end
  end

  class ConnectionInfoError < Error
  end

  class InvalidClientIdOrSecretError < Error
    def initialize
      super("Invalid Client Id or Client Secret")
    end
  end
end
