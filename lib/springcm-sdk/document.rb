require "springcm-sdk/resource"
require "springcm-sdk/mixins/access_level"

module Springcm
  class Document < Resource
    include Springcm::AccessLevel
    include Springcm::ParentFolder

    def self.resource_params
      {
        "expand" => "attributegroups"
      }
    end
  end
end
