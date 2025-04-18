class DeviceAssignment < ApplicationRecord
  belongs_to :device
  belongs_to :user
  
  validates :assigned_at, presence: true
  
  scope :active, -> { where(returned_at: nil) }
  scope :returned, -> { where.not(returned_at: nil) }
  
  def returned?
    returned_at.present?
  end
  
  def return!
    update!(returned_at: Time.current)
  end
end