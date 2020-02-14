module Springcm
  class Object
    def initialize(data, client)
      @client = client
      @data = data
    end

    # Retrieve a top-level property of the object's JSON data.
    #
    # For convenience, top-level properties of a SpringCM object's JSON data
    # are accessible via instance methods (underscore format), e.g.
    # attribute_groups to retrieve JSON for $.AttributeGroups. This can be and
    # is often overridden by inheriting classes by defining a method and
    # extending what it does. Some mixins also provide convenience methods
    # for retrieving data deeper in the JSON document, e.g. documents_href
    # via Springcm::Mixins::Documents.
    def method_missing(m, *args, &block)
      mode = :get
      method = m.to_s
      if method.end_with?("=")
        mode = :set
        method = method[0...-1]
      end
      key = method.split("_").map(&:capitalize).join
      if @data.key?(key)
        if mode == :get
          @data.fetch(key)
        else
          @data[key] = args.first
        end
      else
        super
      end
    end

    # Retrieve the raw JSON document for this object.
    def raw
      @data
    end
  end
end
