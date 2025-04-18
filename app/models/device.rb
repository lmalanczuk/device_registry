# frozen_string_literal: true

class Device < ApplicationRecord
  belongs_to :user, optional: true
  has_many :device_assignments, dependent: :destroy
  has_many :previous_users, -> { distinct }, through: :device_assignments, source: :user
  
  validates :serial_number, presence: true, uniqueness: true

  def assigned?
    user.present?
  end

  def previously_assigned_to?(user)
    return false unless persisted?
    device_assignments.returned.where(user: user).exists?
  end
  
  def active_assignment
    device_assignments.active.first
  end
end