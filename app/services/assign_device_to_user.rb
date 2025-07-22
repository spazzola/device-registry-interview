# frozen_string_literal: true

class AssignDeviceToUser
  def initialize(requesting_user:, serial_number:, new_device_owner_id:)
    @requesting_user = requesting_user
    @serial_number = serial_number
    @new_device_owner_id = new_device_owner_id
  end

  def call
    device = Device.find_or_initialize_by(serial_number: @serial_number)

    if device.persisted?
      if device.user_id && device.user_id != @requesting_user.id
        #TODO throw an error
      end

      if device.returned_by_id == @requesting_user.id
        #TODO throw an error
      end
    end

    device.user_id = @requesting_user.id
    device.returned_by_id = nil
    device.save!

    device
  end
end