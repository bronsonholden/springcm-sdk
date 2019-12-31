class Builder
  attr_reader :client

  def initialize(client)
    @client = client
    @values = {}
    defaults = properties.reject { |p| p[:default].nil? }
    defaults.each { |p|
      @values[p[:key]] = p[:default]
    }
  end

  def data
    {}
  end

  def method_missing(m, *args, &block)
    # If not a property
    return super if !property_keys.include?(m)
    # If no args, behave like a getter
    return @values[m] if !args.any?

    # Get property definition
    prop = property_by_key(m)

    # If it has a validator, call it
    validate = prop[:validate]
    validate.call(*args) if validate.respond_to?(:call)

    # The value to set
    val = args.first

    # If it has an argument collector, call it and use that value instead
    collect = prop[:collect]
    val = collect.call(*args) if collect.respond_to?(:call)

    if !val.is_a?(prop[:type])
      raise ArgumentError.new("Invalid property value #{val.inspect}, must be: #{prop[:type]}")
    end

    # Set value
    @values[m] = val

    # Return self to chain calls
    self
  end

  def self.property(key, type: nil, default: nil, validate: nil, collect: nil)
    if !default.nil? && type.nil?
      type = default.class
    end

    @properties ||= []
    @properties.push({
      key: key,
      type: type,
      default: default,
      validate: validate,
      collect: collect
    })
  end

  protected

  def properties
    self.class.instance_variable_get(:@properties) || []
  end

  def property_keys
    properties.map { |p| p[:key] }
  end

  def property_by_key(key)
    properties.select { |p| p[:key] == key }.last
  end
end
