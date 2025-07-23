class ReturnDeviceFromUser
  def initialize(user:, serial_number:)
    @user = user
    @serial_number = serial_number

    validate_params!
  end

  def call
    device = Device.find_by(serial_number: @serial_number)

    check_if_can_return(device)
    
    device.user = nil
    device.save!

    device
  end
  

  private

  def validate_params!
    raise ArgumentError, 'user is required' if @user.nil?
    raise ArgumentError, 'serial_number is required' if @serial_number.nil? || @serial_number.strip.empty?
  end

  def check_if_can_return(device)
    if device.nil? || device.user_id != @user.id
      raise ReturnError::Unauthorized
    end
  end

end