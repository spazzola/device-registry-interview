class Device < ApplicationRecord
  belongs_to :user, optional: true
  has_many :returns_histories
end
