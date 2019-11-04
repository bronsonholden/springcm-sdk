require "springcm-sdk/folder"

class PageBuilder
  def initialize(client)
    @client = client
    # TODO: Require Href be set
    @href = ""
    @items = []
    @limit = 20
    @offset = 0
  end

  def href(val)
    @href = val
    self
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
    # TODO: Require Href be set
    {
      "Items" => paged_items,
      "Href" => @href,
      "Offset" => @offset,
      "Limit" => @limit,
      "First" => first_href,
      "Last" => last_href,
      "Total" => total
    }
  end

  protected

  def total
    @items.size
  end

  def first_href
    if total <= @limit
      @href
    else
      # TODO: Add offset/limit params to returned Href
      @href
    end
  end

  def last_href
    if total <= @limit
      @href
    else
      # TODO: Add offset/limit params to returned Href
      @href
    end
  end

  def paged_items
    from = @offset
    to = from + @limit
    page_items = @items[from...to] || []
    page_items.map { |builder| builder.data }
  end
end
