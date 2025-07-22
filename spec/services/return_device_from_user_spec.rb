# frozen_string_literal: true

require 'rspec'

RSpec.describe ReturnDeviceFromUser do
  let(:user) { create(:user)}
  let(:serial_number) { '123456' }
  let(:device) { create(:device, serial_number: serial_number, user: user) }

end
