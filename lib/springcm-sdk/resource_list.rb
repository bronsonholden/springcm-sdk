module Springcm
  class ResourceList < Object
    def initialize(data, parent_object, kind, client)
      @parent_object = parent_object
      @kind = kind
      super(data, client)
    end

    def next
      nav_list("Next")
    end

    def prev
      nav_list("Previous")
    end

    def first
      nav_list("First")
    end

    def last
      nav_list("Last")
    end

    def items
      @data.fetch("Items", []).map { |item|
        @kind.new(item, @client)
      }
    end

    private

    def nav_list(mode)
      url = @data.fetch(mode, nil)
      return nil if url.nil?
      method = method_for_kind!(@kind)
      uri = URI(url)
      query = CGI.parse(uri.query || "")
      offset = query.fetch("offset", ["0"]).first.to_i
      limit = query.fetch("limit", ["20"]).first.to_i
      @parent_object.send(method, offset: offset, limit: limit)
    end

    def method_for_kind!(kind)
      method = nil
      if kind == Springcm::Folder
        method = :folders
      elsif kind == Springcm::Document
        method = :documents
      elsif kind == Springcm::AttributeGroup
        method = :attribute_groups
      else
        raise ArgumentError.new("Resource kind must be one of: Springcm::Document, Springcm::Folder, Springcm::AttributeGroup.")
      end
      return method
    end
  end
end
