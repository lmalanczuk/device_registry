# frozen_string_literal: true

class ReturnDeviceFromUser
  def initialize(requesting_user:,serial_number:)
    @requesting_user = requesting_user
    @serial_number = serial_number
    @device = Device.find_by!(serial_number: @serial_number)
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
                    raise StandardError, "Device is not assigned to any user"
        end

        unless @device.user_id == @requesting_user.id
                    raise StandardError, "Only the user who has the device assigned can return it"
        end
  end

  def return_device
        assignment = DeviceAssignment.where(device: @device, user: @requesting_user).active.first

        assignment.return! if assignment

        @device.update!(user: nil)

        assignment
  end
end
