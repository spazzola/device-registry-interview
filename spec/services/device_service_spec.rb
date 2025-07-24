# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeviceService do
  subject(:assign_device) do
    described_class.new.assign_device_to_user(
      requesting_user: user,
      serial_number: serial_number,
      new_device_owner_id: new_device_owner_id
    )
  end
  
  subject(:return_device) do
    described_class.new.return_device_from_user(
      user: user,
      serial_number: serial_number
    )
  end

  let(:user) { create(:user) }
  let(:serial_number) { '123456' }
  let(:new_device_owner_id) { create(:user).id }

  context 'when users registers a device to other user' do

    it 'raises an error' do
      expect { assign_device }.to raise_error(RegistrationError::Unauthorized)
    end
  end

  context 'when user registers a device on self' do
    let(:new_device_owner_id) { user.id }

    it 'creates a new device' do
      assign_device

      expect(user.devices.pluck(:serial_number)).to include(serial_number)
    end

    context 'when a user tries to register a device that was already assigned to and returned by the same user' do
      before do
        assign_device
        @device = DeviceService.new.return_device_from_user(user: user, serial_number: serial_number)
      end

      it 'does not allow to register' do
          expect { DeviceService.new.assign_device_to_user(
            requesting_user: user,
            serial_number: serial_number,
            new_device_owner_id: user.id
          )
        }.to raise_error(AssigningError::AlreadyUsedByUser)
      end
    end

    context 'when user tries to register device that is already assigned to other user' do
      let(:other_user) { create(:user) }

      before do
        DeviceService.new.assign_device_to_user(
          requesting_user: other_user,
          serial_number: serial_number,
          new_device_owner_id: other_user.id
        )
      end

      it 'does not allow to register' do
        expect { assign_device }.to raise_error(AssigningError::AlreadyUsedOnOtherUser)
      end
    end
  end

  context 'when users registers a device incorrect params' do
    it 'raises an ArgumentError if requesting_user is nil' do
      expect {         
        DeviceService.new.assign_device_to_user(
          requesting_user: nil,
          serial_number: "123456",
          new_device_owner_id: 1
        )
      }.to raise_error(ArgumentError, 'user is required')
    end

    it 'raises an ArgumentError if serial_number is empty string' do
      expect {         
        DeviceService.new.assign_device_to_user(
          requesting_user: user,
          serial_number: " ",
          new_device_owner_id: 1
        ) 
      }.to raise_error(ArgumentError, 'invalid value for serial_number')
    end

    it 'raises an ArgumentError if new_device_owner_id is less than 0' do
      expect {         
        DeviceService.new.assign_device_to_user(
          requesting_user: user,
          serial_number: "ds",
          new_device_owner_id: -1
        )
      }.to raise_error(ArgumentError, 'invalid id')
    end
  end

  context 'returns device successfully' do
    let(:new_device_owner_id) { user.id }
    before do
      assign_device
      @device = DeviceService.new.return_device_from_user(user: user, serial_number: serial_number)
    end

    it 'returns device and unassign user' do
      @device.reload
      expect(@device.serial_number).to eq(serial_number)
      expect(@device.user).to eq(nil)
    end
  end

  context 'when user returns a device that is assigned to another user ' do
    let(:other_user) { create(:user)}

      it 'raises an error' do
        expect { 
          DeviceService.new.return_device_from_user(user: user, serial_number: serial_number)
        }.to raise_error(ReturnError::Unauthorized)
     end
  end

  context 'when users returns a device incorrect params' do
    it 'raises an ArgumentError if user is nil' do
      expect {         
        DeviceService.new.return_device_from_user(user: nil, serial_number: serial_number
        )
      }.to raise_error(ArgumentError, 'user is required')
    end

    it 'raises an ArgumentError if serial_number is empty string' do
      expect {         
        DeviceService.new.return_device_from_user(user: user, serial_number: " ") 
      }.to raise_error(ArgumentError, 'invalid value for serial_number')
    end
  end
end
