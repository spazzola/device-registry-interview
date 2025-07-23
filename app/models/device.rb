class Device < ApplicationRecord
  validates: @serial_number, presense: true, unique: true
  belongs_to :user, optional: true
  has_many :returns_histories
end
