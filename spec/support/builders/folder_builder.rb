require "springcm/folder"

# Builds folder JSON for use in testing
class FolderBuilder
  def initialize(client)
    @client = client
    @name = "Folder"
    @created_date = Time.utc(2000, "jan", 1, 0, 0, 0)
    @updated_date = Time.utc(2000, "jan", 1, 0, 0, 0)
    @created_by = "folderbuilder@website.com"
    @updated_by = "folderbuilder@website.com"
    @description = "A folder"
    @access = Set.new
  end

  def name(val)
    @name = val
    self
  end

  def uid(val)
    raise ArgumentError.new("Invalid UID #{val}") if !UUID.validate(val)
    @uid = val
    self
  end

  def created_date(val)
    raise ArgumentError.new("Invalid Time #{val.inspect}") if !val.is_a?(Time)
    @created_date = val
    self
  end

  def updated_date(val)
    raise ArgumentError.new("Invalid Time #{val.inspect}") if !val.is_a?(Time)
    @updated_date = val
    self
  end

  def created_by(val)
    @created_by = val
    self
  end

  def updated_by(val)
    @updated_by = val
    self
  end

  def description(val)
    @description = val
    self
  end

  def access(*args)
    allowed = Set[:see, :read, :write, :move, :create, :set_access]
    new_access = Set[*args]
    invalid = new_access - allowed
    if invalid.size > 0
      raise ArgumentError.new("Invalid access setting(s) #{invalid.inspect}")
    end
    @access = new_access
    self
  end

  def build
    nil if !valid?
    Springcm::Folder.new(data, @client)
  end

  def valid?
    !@uid.nil?
  end

  def data
    {
        "Name" => "#{@name}",
        "CreatedDate" => "#{@created_date.strftime("%FT%T.%3NZ")}",
        "CreatedBy" => "#{@created_by}",
        "UpdatedDate" => "#{@updated_date.strftime("%FT%T.%3NZ")}",
        "UpdatedBy" => "#{@updated_by}",
        "Description" => "#{@description}",
        "BrowseDocumentsUrl" => "https://uatna11.springcm.com/atlas/Link/Folder/0/#{@uid}",
        "AccessLevel" => {
            "See" => @access.include?(:see),
            "Read" => @access.include?(:read),
            "Write" => @access.include?(:write),
            "Move" => @access.include?(:move),
            "Create" => @access.include?(:create),
            "SetAccess" => @access.include?(:set_access)
        },
        "Documents" => {
            "Href" => "#{@client.object_api_url}/folders/#{@uid}/documents"
        },
        "Folders" => {
            "Href" => "#{@client.object_api_url}/folders/#{@uid}/folders"
        },
        "ShareLinks" => {
            "Href" => "#{@client.object_api_url}/folders/#{@uid}/sharelinks"
        },
        "CreateDocumentHref" => "#{@client.upload_api_url}/v201411/folders/#{@uid}/documents{?name}",
        "Href" => "#{@client.object_api_url}/folders/#{@uid}"
    }
  end
end
