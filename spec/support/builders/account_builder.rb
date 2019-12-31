# Builder for SpringCM Accounts (account metadata).
class AccountBuilder < Builder
  property :id, type: String, default: rand(1000..9999).to_s, validate: -> (*args) {
    account_id = args.first
    if !account_id.is_a?(String) || account_id.to_i < 1
      raise ArgumentError.new("Account ID must be a positive, non-zero integer as a String")
    end
  }

  property :name, default: "My SpringCM Account", validate: -> (*args) {
    name = args.first
    if !name.is_a?(String) || name.size < 1
      raise ArgumentError.new("Account name must be a String with non-zero length")
    end
  }

  property :type, default: "Enterprise"
  property :default_culture, default: "en-US"
  property :default_time_zone, default: "(UTC-08:00) Pacific Time (US & Canada)"

  def build
    Springcm::Account.new(data, client)
  end

  def data
    {
      "Id" => id,
      "Name" => name,
      "DefaultCulture" => default_culture,
      "DefaultTimeZone" => default_time_zone,
      "AttributeGroups" => {
        "Href" => "#{client.object_api_url}/accounts/current/attributegroups"
      },
      "BrandingUrl" => "", # TODO
      "Href" => "#{client.object_api_url}/accounts/current"
    }
  end
end
