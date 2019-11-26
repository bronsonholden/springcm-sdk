module Springcm
  module Helpers
    # Validate an offset and limit pair.
    def self.validate_offset_limit!(offset, limit)
      if !limit.is_a?(Integer) || limit < 1 || limit > 1000
        raise ArgumentError.new("Limit must be an integer between 1 and 1000 (inclusive).")
      end

      if !offset.is_a?(Integer) || offset < 0
        raise ArgumentError.new("Offset must be a positive, non-zero integer.")
      end
    end
  end
end
