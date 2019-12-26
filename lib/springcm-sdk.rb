require "springcm-sdk/version"
require "springcm-sdk/client"

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

  class AuthExpiredError < Error
    def initialize
      super("Authorization expired")
    end
  end

  class RateLimitExceededError < Error
    def initialize
      super("Rate limit exceeded")
    end
  end
end
