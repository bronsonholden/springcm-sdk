require "springcm/object"
require "springcm/access_level"

module Springcm
  class Document < Object
    include Springcm::AccessLevel
  end
end
