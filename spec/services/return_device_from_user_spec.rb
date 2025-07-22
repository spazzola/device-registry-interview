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
      expect(@device.serial_number).to eq(serial_number)
      expect(@device.user).to eq(nil)
    end
  end

end
