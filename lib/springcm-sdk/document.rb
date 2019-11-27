require "springcm-sdk/resource"
require "springcm-sdk/mixins/access_level"
require "springcm-sdk/mixins/attributes"

module Springcm
  class Document < Resource
    include Springcm::Mixins::AccessLevel
    include Springcm::Mixins::ParentFolder
    include Springcm::Mixins::Attributes

    def self.resource_params
      {
        "expand" => "attributegroups"
      }
    end
  end
end
