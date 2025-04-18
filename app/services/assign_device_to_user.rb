# frozen_string_literal: true

class AssignDeviceToUser
  def initialize(requesting_user:, serial_number:, new_device_owner_id:)
    @requesting_user = requesting_user
    @serial_number = serial_number
    @new_device_owner_id = new_device_owner_id.to_i
    @device = Device.find_or_initialize_by(serial_number: @serial_number)
    @new_owner = User.find_by(id: @new_device_owner_id)
    
    raise StandardError, "New owner not found" unless @new_owner
  end

  def call
    ActiveRecord::Base.transaction do
      validate_assignment
      assign_device
    end
  end

  private

  def validate_assignment
    unless @requesting_user.id == @new_device_owner_id
      raise RegistrationError::Unauthorized
    end

    if @device.persisted? && @device.assigned? && @device.user_id != @new_device_owner_id
      raise AssigningError::AlreadyUsedOnOtherUser
    end

    if @device.persisted? && @device.previously_assigned_to?(@new_owner)
      raise AssigningError::AlreadyUsedOnUser
    end
  end

  def assign_device
    @device.save! if @device.new_record?
    
    assignment = DeviceAssignment.create!(
      device: @device,
      user: @new_owner,
      assigned_at: Time.current
    )
    
    @device.update!(user: @new_owner)
    
    assignment
  end
end