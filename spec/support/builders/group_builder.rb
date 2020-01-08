require "springcm-sdk/group"
require_relative "builder"

# Builder for SpringCM Groups.
class GroupBuilder < Builder
  property :uid, default: UUID.generate, validate: -> (uid) {
    raise ArgumentError.new("Invalid UID #{uid.inspect}") if !UUID.validate(uid)
  }

  property :name, default: "Group"
  property :description, default: "A group"
  property :group_type, default: "Security", validate: -> (type) {
    types = ["Distribution", "Security"]
    if !types.include?(type)
      raise ArgumentError.new("Invalid group type; must be one of: #{types.join(', ')}")
    end
  }
  property :created_date, default: Time.utc(2000, "jan", 1, 0, 0, 0)
  property :updated_date, default: Time.utc(2000, "jan", 1, 0, 0, 0)

  def build
    nil if !valid?
    Springcm::Group.new(data, client)
  end

  def valid?
    !@uid.nil?
  end

  def data
    {
      "Name" => "#{name}",
      "Description" => "#{description}",
      "GroupType" => group_type,
      "GroupMembers" => {
        "Href" => "#{client.object_api_url}/groups/#{uid}/groupmembers"
      },
      "CreatedDate" => "#{created_date.strftime("%FT%T.%3NZ")}",
      "UpdatedDate" => "#{updated_date.strftime("%FT%T.%3NZ")}",
      "Href" => "#{client.object_api_url}/groups/#{uid}"
    }
  end
end
