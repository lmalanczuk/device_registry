class Device < ApplicationRecord
  belongs_to :user, optional: true
  has_many :device_assignments, dependent: :destroy
  validates :serial_number, presence: true, uniqueness: true


  def assigned?
    user.present?
  end

  def previously_assigned_to?(user)
    device_assignments.where(user: user).exists?
  end
end
