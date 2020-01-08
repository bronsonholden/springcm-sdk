require "springcm-sdk/user"
require_relative "builder"

# Builder for SpringCM Users.
class UserBuilder < Builder
  property :uid, default: UUID.generate, validate: -> (uid) {
    raise ArgumentError.new("Invalid UID #{uid.inspect}") if !UUID.validate(uid)
  }

  property :email, default: "johndoe@email.com"
  property :user_name, default: "johndoe@email.com"
  property :first_name, default: "John"
  property :last_name, default: "Doe"
  property :role, default: "SuperAdministrator"
  property :created_date, default: Time.utc(2000, "jan", 1, 0, 0, 0)
  property :updated_date, default: Time.utc(2000, "jan", 1, 0, 0, 0)

  property :managed_by, type: Springcm::User

  def build
    nil if !valid?
    Springcm::User.new(data, client)
  end

  def valid?
    !@uid.nil?
  end

  def data
    {
      "Email" => email,
      "UserName" => user_name,
      "FirstName" => first_name,
      "LastName" => last_name,
      "ManagedUsers" => {
        "Href" => "#{client.object_api_url}/users/#{uid}/managedusers"
      },
      "WorkItems" => {
        "Href" => "#{client.object_api_url}/users/#{uid}/workitems"
      },
      "Groups" => {
        "Href" => "#{client.object_api_url}/users/#{uid}/groups"
      },
      "Role" => role,
      "Coutry" => "US",
      "CreatedDate" => "#{created_date.strftime("%FT%T.%3NZ")}",
      "UpdatedDate" => "#{updated_date.strftime("%FT%T.%3NZ")}",
      "Href" => "#{client.object_api_url}/users/#{uid}"
    }
  end
end
