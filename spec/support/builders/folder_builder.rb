require "springcm/folder"
require_relative "mixins/uid"
require_relative "mixins/name"
require_relative "mixins/description"
require_relative "mixins/created"
require_relative "mixins/updated"
require_relative "mixins/access"

# Builds folder JSON for use in testing
class FolderBuilder
  include UidMixin
  include NameMixin
  include DescriptionMixin
  include CreatedMixin
  include UpdatedMixin
  include AccessMixin

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
