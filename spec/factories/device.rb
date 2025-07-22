# frozen_string_literal: true

FactoryBot.define do
  factory :device do
    serial_number { '123456' }
    user { nil }
  end
end
