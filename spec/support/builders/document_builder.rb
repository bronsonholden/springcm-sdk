require "springcm-sdk/document"
require "springcm-sdk/folder"
require_relative "builder"

class DocumentBuilder < Builder
  property :uid, default: UUID.generate, validate: -> (uid) {
    raise ArgumentError.new("Invalid UID #{uid.inspect}") if !UUID.validate(uid)
  }

  property :name, default: "Folder"
  property :description, default: "A folder"
  property :created_date, default: Time.utc(2000, "jan", 1, 0, 0, 0)
  property :updated_date, default: Time.utc(2000, "jan", 1, 0, 0, 0)
  property :created_by, default: "FolderBuilder"
  property :updated_by, default: "FolderBuilder"
  property :access, default: Set[:see, :read, :write, :move, :create, :set_access], validate: -> (*args) {
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

  property :page_count, default: 1, validate: -> (*args) {
    count = args.first
    if !count.is_a?(Integer) || count < 1
      raise ArgumentError.new("Invalid page count (must be a non-zero Integer)")
    end
  }

  property :file_size, default: 1e6, type: Integer, validate: -> (*args) {
    size = args.first
    if !size.is_a?(Integer) || size < 1
      raise ArgumentError.new("Invalid file size (must be a positive, non-zero Integer)")
    end
  }

  def build
    Springcm::Document.new(data, client)
  end

  def data
    {
      "Name" => "#{name}",
      "CreatedDate" => "#{created_date.strftime("%FT%T.%3NZ")}",
      "CreatedBy" => "#{created_by}",
      "UpdatedDate" => "#{updated_date.strftime("%FT%T.%3NZ")}",
      "UpdatedBy" => "#{updated_by}",
      "Description" => "#{description}",
      "ParentFolder" => {
        "Href" => "#{client.object_api_url}/folders/c0ca34aa-3774-e611-bb8d-6c3be5a75f4d"
      },
      "HistoryItems" => {
        "Href" => "#{client.object_api_url}/documents/0063805f-9b42-e811-9c12-3ca82a1e3f41/historyitems"
      },
      "AccessLevel" => {
        "See" => access.include?(:see),
        "Read" => access.include?(:read),
        "Write" => access.include?(:write),
        "Move" => access.include?(:move),
        "Create" => access.include?(:create),
        "SetAccess" => access.include?(:set_access)
      },
      "AttributeGroups" => { # TODO: Allow building attributes
        "Attribute Group" => {
          "Field" => {
            "AttributeType" => "String",
            "RepeatingAttribute" => false,
            "Value" => "A"
          },
          "Attribute Set" => {
            "AttributeType" => "Set",
            "RepeatingAttribute" => false,
            "Attribute Set Field" => {
              "AttributeType" => "String",
              "RepeatingAttribute" => false,
              "Value" => "B"
            }
          },
          "Repeatable Attribute Set" => {
            "Items" => [
              {
                "Repeatable Attribute Set Field" => {
                  "AttributeType" => "String",
                  "RepeatingAttribute" => false,
                  "Value" => "1"
                }
              },
              {
                "Repeatable Attribute Set Field" => {
                  "AttributeType" => "String",
                  "RepeatingAttribute" => false,
                  "Value" => "2"
                }
              },
              {
                "Repeatable Attribute Set Field" => {
                  "AttributeType" => "String",
                  "RepeatingAttribute" => false,
                  "Value" => "3"
                }
              }
            ],
            "AttributeType" => "Set",
            "RepeatingAttribute" => true
          },
          "Repeatable Field" => {
            "AttributeType" => "String",
            "RepeatingAttribute" => true,
            "Value" => [
              "R1",
              "R2",
              "R3"
            ]
          },
          "Number Field" => {
            "AttributeType" => "Number",
            "RepeatingAttribute" => false,
            "Value" => "123"
          },
          "Date Field" => {
            "AttributeType" => "Date",
            "RepeatingAttribute" => false,
            "Value" => "20191101000000"
          },
          "Drop Down Field" => {
            "AttributeType" => "DropDown",
            "RepeatingAttribute" => false,
            "Value" => "Option 1"
          },
          "Decimal Field" => {
            "AttributeType" => "Decimal",
            "RepeatingAttribute" => false,
            "Value" => "1.22"
          },
          "Auto Number Field" => {
            "AttributeType" => "AutoNumber",
            "RepeatingAttribute" => false,
            "Value" => "6"
          },
          "Dynamic Drop Down Field" => {
            "AttributeType" => "MagicDropDown",
            "RepeatingAttribute" => false,
            "Value" => "Dynamic Option 1"
          },
          "Cascading Attribute Set" => {
            "AttributeType" => "Set",
            "RepeatingAttribute" => false,
            "Cascading Field 1" => {
              "AttributeType" => "Cascade",
              "RepeatingAttribute" => false,
              "Value" => "Cascading Value 1.1"
            },
            "Cascading Field 2" => {
              "AttributeType" => "Cascade",
              "RepeatingAttribute" => false,
              "Value" => "Cascading Value 1.2"
            },
            "Cascading Extension Field" => {
              "AttributeType" => "String",
              "RepeatingAttribute" => false,
              "Value" => "Ext"
            }
          }
        }
      },
      "PageCount" => page_count,
      "Lock" => {
        "Href" => "#{client.object_api_url}/documents/#{uid}/lock"
      },
      # TODO: Preview URLs
      "PreviewUrl" => "https://uatna11.springcm.com/atlas/documents/docexplorer?aid=0&id=#{uid}",
      "Versions" => {
        "Href" => "#{client.object_api_url}/documents/#{uid}/versions"
      },
      "ShareLinks" => {
        "Href" => "#{client.object_api_url}/documents/#{uid}/sharelinks"
      },
      "DocumentProcessTrackingActivities" => {
        "Href": "#{client.object_api_url}/documents/#{uid}/documentprocesstrackingactivities"
      },
      "DocumentReminders" => {
        "Href" => "#{client.object_api_url}/documents/#{uid}/documentreminders"
      },
      "RelatedDocuments" => {
        "Href" => "#{client.object_api_url}/documents/#{uid}/relateddocuments"
      },
      "WorkItems" => {
        "Href" => "#{client.object_api_url}/documents/#{uid}/workitems"
      },
      "DownloadDocumentHref" => "#{client.download_api_url}/documents/#{uid}",
      "NativeFileSize" => file_size,
      "PdfFileSize" => file_size,
      "Href" => "#{client.object_api_url}/documents/#{uid}"
    }
  end
end
