module AccessMixin
  def access(*args)
    allowed = Set[:see, :read, :write, :move, :create, :set_access]
    new_access = Set[*args]
    invalid = new_access - allowed
    if invalid.size > 0
      raise ArgumentError.new("Invalid access setting(s) #{invalid.inspect}")
    end
    @access = new_access
    self
  end
end
