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
        "CreatedDate" => "#{@created_date.strftime("%FT%T.%3NZ")}", # 2000-01-01T00:00:00.000Z
        "CreatedBy" => "#{@created_by}",
        "UpdatedDate" => "#{@updated_date.strftime("%FT%T.%3NZ")}",
        "UpdatedBy" => "#{@updated_by}",
        "Description" => "",
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
            "Href" => "https://apiuatna11.springcm.com/v201411/folders/#{@uid}/documents"
        },
        "Folders" => {
            "Href" => "https://apiuatna11.springcm.com/v201411/folders/#{@uid}/folders"
        },
        "ShareLinks" => {
            "Href" => "https://apiuatna11.springcm.com/v201411/folders/#{@uid}/sharelinks"
        },
        "CreateDocumentHref" => "https://apiuploaduatna11.springcm.com/v201411/folders/#{@uid}/documents{?name}",
        "Href" => "https://apiuatna11.springcm.com/v201411/folders/#{@uid}"
    }
  end
end