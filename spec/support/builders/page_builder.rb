require "springcm-sdk/folder"

class PageBuilder
  def initialize(parent_folder, kind, client)
    @parent_folder = parent_folder
    @kind = kind
    @client = client
    @href = client.object_api_url
    @items = []
    @limit = 20
    @offset = 0
  end

  def limit(val)
    # Raise error here because this is for testing. SpringCM API reverts to
    # a default value if an invalid limit value is provided.
    if !val.is_a?(Integer) || val < 1
      raise ArgumentError.new("Limit value must be a positive, non-zero Integer")
    end
    @limit = val
    self
  end

  def offset(val)
    # Raise error here because this is for testing. SpringCM API reverts to
    # a default value if an invalid offset value is provided.
    if !val.is_a?(Integer) || val < 0
      raise ArgumentError.new("Offset value must be a non-negative Integer")
    end
    @offset = val
    self
  end

  def add(item)
    raise ArgumentError.new("Page item must respond to :build") if !item.respond_to?(:build)
    @items.push(item)
  end

  def build
    data = {
      "Items" => paged_items,
      "Href" => current_href,
      "Offset" => @offset,
      "Limit" => @limit,
      "First" => first_href,
      "Last" => last_href,
      "Total" => total
    }
    if has_next?
      data["Next"] = next_href
    end
    if has_previous?
      data["Previous"] = previous_href
    end
    return data
  end

  protected

  def plural_resource_for_kind(kind)
    if @kind == Springcm::Folder
      return "folders"
    elsif @kind == Springcm::Document
      return "documents"
    end
  end

  def total
    @items.size
  end

  def current_href
    href_at(@offset, @limit)
  end

  def href_at(offset, limit)
    offset = 0 if offset < 0
    url = "#{@href}/folders/#{@parent_folder.uid}/#{plural_resource_for_kind(@kind)}"
    if (offset != 0 || limit != 20)
      url = "#{url}?offset=#{offset}&limit=#{limit}"
    end
    url
  end

  def first_href
    href_at(0, @limit)
  end

  def last_href
    pages = total / @limit
    pages = pages.floor
    href_at(pages * @limit, @limit)
  end

  def aligned_offset?
    return (@offset % @limit) == 0
  end

  def has_next?
    return aligned_offset? && @offset + @limit < total
  end

  def has_previous?
    return aligned_offset? && @offset > 0
  end

  def next_href
    return href_at(@offset + @limit, @limit)
  end

  def previous_href
    return href_at(@offset - @limit, @limit)
  end

  def paged_items
    from = @offset
    to = from + @limit
    page_items = @items[from...to] || []
    page_items.map { |builder| builder.data }
  end
end
