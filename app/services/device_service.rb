# frozen_string_literal: true

class DeviceService
  def initialize
  end

  def assign_device_to_user(requesting_user:, serial_number:, new_device_owner_id:)
    @requesting_user = requesting_user
    @serial_number = serial_number
    @new_device_owner_id = new_device_owner_id

    validate_assign!

    device = Device.find_or_initialize_by(serial_number: @serial_number)

    validate_device(device)
    create_device_object(device)
    create_return_history(device)

    device
  end

  def return_device_from_user(user:, serial_number:)
    @user = user
    @serial_number = serial_number

    validate_return!

    device = Device.find_by(serial_number: @serial_number)
    check_if_can_return(device)

    device.user = nil
    device.save!

    device
  end

  private

  def validate_assign!
    raise RegistrationError::Unauthorized unless assigning_to_self?

    ValidationService.validate_user(@requesting_user)
    ValidationService.validate_string(@serial_number, "serial_number")
    ValidationService.validate_id(@new_device_owner_id)
  end

  def validate_return!
    ValidationService.validate_user(@user)
    ValidationService.validate_string(@serial_number, "serial_number")
  end

  def assigning_to_self?
    @requesting_user.id == @new_device_owner_id
  end

  def validate_device(device)
    if device.persisted?
      if device.user_id && device.user_id != @requesting_user.id
        raise AssigningError::AlreadyUsedOnOtherUser
      end

      check_if_was_returned_by_user(device)
    end
  end

  def create_device_object(device)
    device.user_id = @requesting_user.id
    device.returned_by_id = nil
    device.save!
  end

  def create_return_history(device)
    return_history = ReturnsHistory.new(user: @requesting_user, device: device)
    return_history.save!
  end

  def check_if_was_returned_by_user(device)
    if device.returned_by_id == @requesting_user.id
      raise AssigningError::AlreadyUsedByUser
    end

    if ReturnsHistory.exists?(user_id: @requesting_user.id, device_id: device.id)
      raise AssigningError::AlreadyUsedByUser
    end
  end

  def check_if_can_return(device)
    if device.nil? || device.user_id != @user.id
      raise ReturnError::Unauthorized
    end
  end
end
