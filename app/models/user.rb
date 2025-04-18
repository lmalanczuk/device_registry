class User < ApplicationRecord
  has_many :api_keys, as: :bearer
  has_many :device_assignments, dependent: :nullify
  has_many :devices, through: :device_assignments
  
  has_secure_password

  validates :email, presence: true, uniqueness: true
end