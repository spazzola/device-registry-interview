# frozen_string_literal: true

class AssignDeviceToUser
  def initialize(requesting_user:, serial_number:, new_device_owner_id:)
    @requesting_user = requesting_user
    @serial_number = serial_number
    @new_device_owner_id = new_device_owner_id
  end

  def call
    device = Device.find_or_initialize_by(serial_number: @serial_number)

    validate_device(device);
    create_device_object(device);

    device
  end


  private

  def validate_device(device)
    if device.persisted?
      if device.user_id && device.user_id != @requesting_user.id
        throw AssigningError::AlreadyUsedOnOtherUser
      end

      if device.returned_by_id == @requesting_user.id
        #TODO throw an error
      end
    end
  end

  def create_device_object(device)
    device.user_id = @requesting_user.id
    device.returned_by_id = nil
    device.save!
  end
end