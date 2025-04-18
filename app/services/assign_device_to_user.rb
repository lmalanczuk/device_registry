# frozen_string_literal: true

class AssignDeviceToUser
  def initialize(requesting_user:, serial_number:, new_device_owner_id:)
    @requesting_user = requesting_user
    @serial_number = serial_number
    @new_device_owner_id = new_device_owner_id.to_i
    @device = Device.find_by!(serial_number: @serial_number)
    @new_owner = User.find(@new_device_owner_id)
  end

  def call
    ActiveRecord::Base.transaction do
            validare_assignment
            assign_device
    end
  end

  private

  def validate_assignment
    unless @requesting_user.id == @new_device_owner_id
            raise StandardError, "You can only assign devices to yourself"
    end

    if @device.assigned?
            raise StandardError, "Device is already assigned to other user"
    end

    if @device.previously_assigned_to?(@new_owner)
            raise StandardError, "You cannot reassign a device you previously returned"
    end
  end

  def assign_device
        assignment = DeviceAssignment.create!(
          device: @device,
          user: @new_owner,
          assigned_at: Time.current
        )
        @device.update!(user: @new_owner)

        assignment
  end
end
