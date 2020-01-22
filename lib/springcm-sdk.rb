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

  class NoAttributeSetError < Error
    def initialize(group, set)
      super("No such attribute set: #{group}.#{set}")
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

  class ChangeSecurityTaskAwaitTimeout < Error
    def initialize
      super("Timed out while awaiting ChangeSecurityTask to complete.")
    end
  end

  class RepeatableAttributeSetUsageError < Error
    def initialize(group, set)
      super("The attribute set #{group}.#{set} is repeatable. Use #[] to access and modify fields.")
    end
  end

  class NonRepeatableAttributeSetUsageError < Error
    def initialize(group, set)
      super("The attribute set #{group}.#{set} is not repeatable. Use #field to access and modify fields.")
    end
  end

  class RepeatableAttributeFieldUsageError < Error
    def initialize(group, field)
      super("The attribute field #{group}.#{field} is repeatable. Use #[] to access and modify values.")
    end
  end

  class NonRepeatableAttributeFieldUsageError < Error
    def initialize(group, field)
      super("The attribute field #{group}.#{field} is not repeatable. Use #field to access and modify values.")
    end
  end
end
