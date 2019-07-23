module CreatedMixin
  def created_date(val)
    raise ArgumentError.new("Invalid Time #{val.inspect}") if !val.is_a?(Time)
    @created_date = val
    self
  end

  def created_by(val)
    @created_by = val
    self
  end
end
