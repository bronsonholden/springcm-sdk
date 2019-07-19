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

  def build
    nil if !valid?
    Springcm::Folder.new(data, @client)
  end

  def valid?
    !@uid.nil?
  end

  private

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
            "See" => true,
            "Read" => true,
            "Write" => true,
            "Move" => true,
            "Create" => true,
            "SetAccess" => true
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
