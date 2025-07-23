# frozen_string_literal: true

class AssignDeviceToUser
  def initialize(requesting_user:, serial_number:, new_device_owner_id:)
    @requesting_user = requesting_user
    @serial_number = serial_number
    @new_device_owner_id = new_device_owner_id

    validate_params!
  end

  def call 
    raise RegistrationError::Unauthorized unless assigning_to_self?

    device = Device.find_or_initialize_by(serial_number: @serial_number)

    validate_device(device);
    create_device_object(device);
    create_return_history(device)

    device
  end


  private

  def validate_params!
    raise ArgumentError, 'requesting_user is required' if @requesting_user.nil?
    raise ArgumentError, 'serial_number is required' if @serial_number.nil? || @serial_number.strip.empty?
    raise ArgumentError, 'invalid new_device_owner_id' if @new_device_owner_id.nil? || @new_device_owner_id <= 0
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

  def assigning_to_self?
    @requesting_user.id == @new_device_owner_id
  end
end