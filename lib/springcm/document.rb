require "springcm/resource"
require "springcm/mixins/access_level"

module Springcm
  class Document < Resource
    include Springcm::AccessLevel
  end
end
