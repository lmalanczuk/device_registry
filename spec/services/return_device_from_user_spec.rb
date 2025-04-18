# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ReturnDeviceFromUser do
  subject(:return_device) do
    described_class.new(
      user: requesting_user,
      serial_number: serial_number,
      from_user: from_user_id
    ).call
  end

  let(:requesting_user) { create(:user) }
  let(:serial_number) { '123456' }
  let(:from_user_id) { requesting_user.id }

  context 'when device is not assigned to any user' do
    before do
      create(:device, serial_number: serial_number)
    end

    it 'raises a NotAssigned error' do
      expect { return_device }.to raise_error(ReturnError::NotAssigned)
    end
  end

  context 'when device is assigned to the user' do
    let(:device) { create(:device, serial_number: serial_number, user: requesting_user) }
    
    before do
      create(:device_assignment, device: device, user: requesting_user, assigned_at: 1.day.ago)
    end

    it 'returns the device' do
      return_device
      expect(device.reload.user).to be_nil
    end

    it 'marks the assignment as returned' do
      assignment = return_device
      expect(assignment.returned?).to be true
    end
  end

  context 'when user tries to return a device assigned to another user' do
    let(:other_user) { create(:user) }
    let(:device) { create(:device, serial_number: serial_number, user: other_user) }
    
    before do
      create(:device_assignment, device: device, user: other_user, assigned_at: 1.day.ago)
    end

    it 'raises an Unauthorized error' do
      expect { return_device }.to raise_error(ReturnError::Unauthorized)
    end
  end
  
  context 'when device does not exist' do
    let(:serial_number) { 'non-existent-serial' }
    
    it 'raises a NotAssigned error' do
      expect { return_device }.to raise_error(ReturnError::NotAssigned)
    end
  end
end