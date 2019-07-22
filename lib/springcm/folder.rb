require "springcm/object"
require "springcm/access_level"

module Springcm
  class Folder < Object
    include Springcm::AccessLevel
  end
end
