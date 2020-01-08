module Springcm
  # A list object of arbitrary SpringCM resources. Allows for easy navigation
  # of paged resources like documents and attribute groups. All resources
  # that are retrieved in this manner are attached to a parent object, e.g.
  # the account for attribute groups, or a folder for documents.
  class ResourceList < Object
    def initialize(data, parent_object, kind, client, method_override: nil)
      @parent_object = parent_object
      @kind = kind
      @method_override = method_override
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

    # TODO: Better pattern for generating related links
    #       Possibly a Springcm::DocumentVersion object?
    def method_for_kind!(kind)
      method = nil
      if !@method_override.nil?
        method = @method_override
      elsif kind == Springcm::Folder
        method = :folders
      elsif kind == Springcm::Document
        method = :documents
      elsif kind == Springcm::AttributeGroup
        method = :attribute_groups
      elsif kind == Springcm::HistoryItem
        method = :history
      elsif kind == Springcm::Group
        method = :groups
      elsif kind == Springcm::User
        method = :users
      else
        raise ArgumentError.new("Resource kind must be one of: Springcm::Document, Springcm::Folder, Springcm::AttributeGroup, Springcm::HistoryItem, Springcm::User, Springcm::Group.")
      end
      return method
    end
  end
end
