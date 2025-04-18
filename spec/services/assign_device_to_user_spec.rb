# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssignDeviceToUser do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:device) { create(:device) }
  
  context 'when users registers a device to other user' do
    let(:assign_device) do
      described_class.new(
        requesting_user: user,
        serial_number: device.serial_number,
        new_device_owner_id: other_user.id
      ).call
    end
    
    it 'raises an error' do
      expect { assign_device }.to raise_error(StandardError, /You can only assign devices to yourself/)
    end
  end
  
  context 'when user registers a device on self' do
    let(:assign_to_self) do
      described_class.new(
        requesting_user: user,
        serial_number: device.serial_number,
        new_device_owner_id: user.id
      ).call
    end
    
    it 'creates a new device' do
      expect { assign_to_self }.to change { DeviceAssignment.count }.by(1)
    end
    
    context 'when a user tries to register a device that was already assigned to and returned by the same user' do
      before do
        create(:device_assignment, device: device, user: user, returned_at: 1.day.ago)
      end
      
      it 'does not allow to register' do
        expect { assign_to_self }.to raise_error(StandardError, /You cannot reassign a device/)
      end
    end
    
    context 'when user tries to register device that is already assigned to other user' do
      before do
        device.update(user: other_user)
      end
      
      it 'does not allow to register' do
        expect { assign_to_self }.to raise_error(StandardError, /Device is already assigned/)
      end
    end
  end
end