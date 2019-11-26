require "springcm-sdk/resource"

module Springcm
  class Attribute < Resource
    def required?
      required
    end

    def read_only?
      read_only
    end

    def repeating_attribute?
      repeating_attribute
    end
  end
end
