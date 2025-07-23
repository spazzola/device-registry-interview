class Device < ApplicationRecord
  validates :serial_number, presence: true, uniqueness: true

  belongs_to :user, optional: true
  has_many :returns_histories
end
