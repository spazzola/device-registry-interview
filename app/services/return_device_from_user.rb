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
    ValidationService.validate_user(@user)
    ValidationService.validate_string(@serial_number, "serial_number")
  end

  def check_if_can_return(device)
    if device.nil? || device.user_id != @user.id
      raise ReturnError::Unauthorized
    end
  end

end