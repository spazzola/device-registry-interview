class ReturnDeviceFromUser
  def initialize(user:, serial_number:)
    @user = user
    @serial_number = serial_number
  end

  def call
    device = Device.find_by(serial_number: @serial_number)

    if device.nil? || device.user_id != @user.id
      raise ReturnError::Unauthorized
    end
    device.user = nil
    device.save!

    device
  end
  
end