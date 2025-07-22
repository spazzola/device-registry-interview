class ReturnDeviceFromUser
  def initialize(user:, serial_number:)
    @user = user
    @serial_number = serial_number
  end

  def call
    device = Device.find_by(serial_number: @serial_number)

    check_if_can_return(device)
    
    device.user = nil
    device.save!

    device
  end
  

  private

  def check_if_can_return(device)
    if device.nil? || device.user_id != @user.id
      raise ReturnError::Unauthorized
    end
  end

end