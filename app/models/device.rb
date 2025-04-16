class Device < ApplicationRecord
  belongs_to :user, optional: true
  validates :serial_number, presence: true, uniqueness: true
end
