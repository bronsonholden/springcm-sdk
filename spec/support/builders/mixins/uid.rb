module UidMixin
  def uid(val)
    raise ArgumentError.new("Invalid UID #{val}") if !UUID.validate(val)
    @uid = val
    self
  end
end
