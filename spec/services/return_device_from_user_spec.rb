# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReturnDeviceFromUser do
  let(:user) { create(:user)}
  let(:serial_number) { '123456' }
  let(:device) { create(:device, serial_number: serial_number, user: user) }

  before do
    @device = AssignDeviceToUser.new(
      requesting_user: user,
      serial_number: serial_number,
      new_device_owner_id: user.id
    ).call
  end

  context 'returns device successfully' do
    before do
      ReturnDeviceFromUser.new(
        user: user,
        serial_number: serial_number
      ).call
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
        expect { ReturnDeviceFromUser.new(
            user: other_user,
            serial_number: serial_number
          ).call 
        }.to raise_error(ReturnError::Unauthorized)
     end
  end

  context 'when users returns a device incorrect params' do
    it 'raises an ArgumentError if user is nil' do
      expect {         
        ReturnDeviceFromUser.new(
          user: nil,
          serial_number: serial_number
        ).call 
      }.to raise_error(ArgumentError, 'user is required')
    end

    it 'raises an ArgumentError if serial_number is empty string' do
      expect {         
        ReturnDeviceFromUser.new(
          user: user,
          serial_number: " "
        ).call 
      }.to raise_error(ArgumentError, 'invalid value for serial_number')
    end
  end
end
