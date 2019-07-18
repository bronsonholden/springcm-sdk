require "springcm/folder"

# Builds folder JSON for use in testing
class FolderBuilder
  def initialize(client)
    @client = client
    @name = "Folder"
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
        "CreatedDate" => "2000-01-01T00:00:00.000Z",
        "CreatedBy" => "support@springcm.com",
        "UpdatedDate" => "2000-01-01T00:00:00.000Z",
        "UpdatedBy" => "System",
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
