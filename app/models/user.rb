class User < ApplicationRecord
  has_many :api_keys, as: :bearer
  has_many :devices
  has_many :returns_histories
  has_secure_password
end
