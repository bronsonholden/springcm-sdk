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

  class NoAttributeGroupError < Error
    def initialize(group)
      super("No such attribute group: #{group}")
    end
  end

  class NoAttributeFieldError < Error
    def initialize(group, field)
      super("No such attribute field: #{group}.#{field}")
    end
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

  class DeleteRefusedError < Error
    def initialize(path)
      super("Refused to delete #{path}, use #delete! instead.")
    end
  end
end
