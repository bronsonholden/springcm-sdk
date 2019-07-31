require "springcm/folder"
require_relative "builder"

# Builds folder JSON for use in testing
class FolderBuilder < Builder
  property :uid, default: UUID.generate, validate: -> (uid) {
    raise ArgumentError.new("Invalid UID #{uid.inspect}") if !UUID.validate(uid)
  }

  property :name, default: "Folder"
  property :description, default: "A folder"
  property :created_date, default: Time.utc(2000, "jan", 1, 0, 0, 0)
  property :updated_date, default: Time.utc(2000, "jan", 1, 0, 0, 0)
  property :created_by, default: "FolderBuilder"
  property :updated_by, default: "FolderBuilder"
  property :access, default: Set.new, validate: -> (*args) {
    allowed = Set[:see, :read, :write, :move, :create, :set_access]
    new_access = Set[*args]
    invalid = new_access - allowed
    if invalid.size > 0
      raise ArgumentError.new("Invalid access setting(s) #{invalid.inspect}")
    end
  }, collect: -> (*args) { Set[*args] }

  property :parent, type: Springcm::Folder, validate: -> (*args) {
    folder = args.first
    if !folder.is_a?(Springcm::Folder)
      raise ArgumentError.new("Invalid parent folder (must be a Springcm::Folder)")
    end
  }

  def initialize(client)
    super
  end

  def build
    nil if !valid?
    Springcm::Folder.new(data, client)
  end

  def valid?
    !@uid.nil?
  end

  def data
    hash = {
      "Name" => "#{name}",
      "CreatedDate" => "#{created_date.strftime("%FT%T.%3NZ")}",
      "CreatedBy" => "#{created_by}",
      "UpdatedDate" => "#{updated_date.strftime("%FT%T.%3NZ")}",
      "UpdatedBy" => "#{updated_by}",
      "Description" => "#{description}",
      "BrowseDocumentsUrl" => "https://uatna11.springcm.com/atlas/Link/Folder/0/#{@uid}",
      "AccessLevel" => {
        "See" => access.include?(:see),
        "Read" => access.include?(:read),
        "Write" => access.include?(:write),
        "Move" => access.include?(:move),
        "Create" => access.include?(:create),
        "SetAccess" => access.include?(:set_access)
      },
      "Documents" => {
        "Href" => "#{client.object_api_url}/folders/#{uid}/documents"
      },
      "Folders" => {
        "Href" => "#{client.object_api_url}/folders/#{uid}/folders"
      },
      "ShareLinks" => {
        "Href" => "#{client.object_api_url}/folders/#{uid}/sharelinks"
      },
      "CreateDocumentHref" => "#{client.upload_api_url}/folders/#{uid}/documents{?name}",
      "Href" => "#{client.object_api_url}/folders/#{uid}"
    }

    if !parent.nil?
      hash.merge!({
        "ParentFolder" => {
          "Href" => parent.href
        }
      })
    end

    return hash
  end
end
