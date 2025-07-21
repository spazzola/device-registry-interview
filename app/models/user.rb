class User < ApplicationRecord
  has_many :api_keys, as: :bearer
  has many :devices
  has_secure_password
end
