module UpdatedMixin
  def updated_date(val)
    raise ArgumentError.new("Invalid Time #{val.inspect}") if !val.is_a?(Time)
    @updated_date = val
    self
  end

  def updated_by(val)
    @updated_by = val
    self
  end
end
