# frozen_string_literal: true

class ReturnDeviceFromUser
  def initialize(user:, serial_number:, from_user: nil)
    @requesting_user = user
    @serial_number = serial_number
    @from_user_id = from_user || user.id
    @device = Device.find_by(serial_number: @serial_number)

    raise ReturnError::NotAssigned unless @device
  end

  def call
    ActiveRecord::Base.transaction do
      validate_return
      return_device
    end
  end

  private

  def validate_return
    unless @device.assigned?
      raise ReturnError::NotAssigned
    end

    unless @device.user_id == @from_user_id
      raise ReturnError::Unauthorized
    end
  end

  def return_device
    assignment = DeviceAssignment.where(device: @device, user_id: @from_user_id).active.first
    
    assignment.return! if assignment
    
    @device.update!(user: nil)
    
    assignment
  end
end