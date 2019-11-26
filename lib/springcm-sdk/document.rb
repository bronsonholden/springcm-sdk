require "springcm-sdk/resource"
require "springcm-sdk/mixins/access_level"

module Springcm
  class Document < Resource
    include Springcm::Mixins::AccessLevel
    include Springcm::Mixins::ParentFolder

    def self.resource_params
      {
        "expand" => "attributegroups"
      }
    end
  end
end
