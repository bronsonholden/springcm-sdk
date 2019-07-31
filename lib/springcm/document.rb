require "springcm/object"
require "springcm/mixins/access_level"

module Springcm
  class Document < Object
    include Springcm::AccessLevel
  end
end
