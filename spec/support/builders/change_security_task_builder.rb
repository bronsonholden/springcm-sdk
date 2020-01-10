require "springcm-sdk/user"
require_relative "builder"

# Builder for SpringCM ChangeSecurityTasks.
class ChangeSecurityTaskBuilder < Builder
  property :status, default: "Waiting", validate: -> (status) {
    status_values = ["Waiting", "Success"]
    if !status_values.include?(status)
      raise ArgumentError.new("Status must be one of: #{status_values.join(", ")}")
    end
  }

  property :folder, type: Springcm::Folder
  # Currently only support setting single group. TODO.
  property :group, type: Springcm::Group
  # TODO
  # property :access, default: :view

  def complete!
    status "Success"
    self
  end

  def build
    return nil if !valid?
    Springcm::ChangeSecurityTask.new(data, client)
  end

  def valid?
    !uid.nil? && !folder.nil? && !group.nil?
  end

  def data
    {
      "Status" => status,
      "Security" => security,
      "Folder" => folder.raw
    }
  end

  def security
    {
      "Groups" => [
        {
          "Item" => group.raw,
          "AccessType" => "View"
        }
      ]
    }
  end
end
