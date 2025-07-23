module ValidationService
  def self.validate_user(user)
    raise ArgumentError, 'user is required' if user.nil?
  end

  def self.validate_string(string, parameter_name)
    raise ArgumentError, "invalid value for #{parameter_name}" if string.nil? || string.strip.empty?
  end

  def self.validate_id(id)
    raise ArgumentError, 'invalid id' if id.nil? || id <= 0
  end
end 