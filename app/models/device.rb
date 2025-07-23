class Device < ApplicationRecord
  validates :serial_number, presense: true, uniqueness: true

  belongs_to :user, optional: true
  has_many :returns_histories
end
