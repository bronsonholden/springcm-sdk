require "springcm-sdk/history_item"
require_relative "builder"

# Builder for SpringCM history entries.
class HistoryItemBuilder < Builder
  property :user_email, default: "johndoe@email.com"
  property :action, default: "Download Document Native", validate: -> (action) {
    # TODO: All possible actions
    actions = [
      "Download Document Native",
      "Document Deleted",
      "Document Moved",
      "Attribute Changed",
      "View Document PDF"
    ]
    raise ArgumentError.new("Invalid history item action #{action}") if !actions.include?(action)
  }
  property :comment, default: "Comment"
  property :more_info, default: ""
  # TODO: User object
  property :user, default: {}
  property :created_date, default: Time.utc(2000, "jan", 1, 0, 0, 0)

  def build
    Springcm::HistoryItem.new(data, client)
  end

  def data
    {
      "UserEmail" => user_email,
      "Action" => action,
      "Comment" => comment,
      "MoreInfo" => more_info,
      "User" => user,
      "CreatedDate" => created_date.strftime("%FT%T.%3NZ")
    }
  end
end
