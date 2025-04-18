# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DevicesController, type: :controller do
  let(:user) { create(:user) }
  let!(:api_key) { create(:api_key, bearer: user) }
  
  describe 'POST #assign' do
    subject(:assign) do
      request.session[:token] = api_key.token
      post :assign, params: params
    end

    let(:serial_number) { '123456' }
    
    context 'when user assigns a device to another user' do
      let(:other_user) { create(:user) }
      let(:params) { { new_owner_id: other_user.id, device: { serial_number: serial_number } } }
      
      it 'returns an unauthorized response' do
        assign
        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)['error']).to eq('Unauthorized')
      end
    end
    
    context 'when user assigns a device to self' do
      let(:params) { { new_owner_id: user.id, device: { serial_number: serial_number } } }
      
      before do
        create(:device, serial_number: serial_number)
      end
      
      it 'returns a success response' do
        assign
        expect(response).to be_successful
      end
    end
    
    context 'when the user is not authenticated' do
      let(:params) { { new_owner_id: user.id, device: { serial_number: serial_number } } }
      
      it 'returns an unauthorized response' do
        post :assign, params: params
        expect(response.status).to eq(401)
      end
    end
  end
  
  describe 'POST #unassign' do
    subject(:unassign) do
      request.session[:token] = api_key.token
      post :unassign, params: { device: { serial_number: serial_number } }
    end
    
    let(:serial_number) { '123456' }
    let(:device) { create(:device, serial_number: serial_number) }
    
    context 'when the device is assigned to the user' do
      before do
        device.update!(user: user)
        create(:device_assignment, device: device, user: user, assigned_at: 1.day.ago)
      end
      
      it 'returns a success response' do
        unassign
        expect(response).to be_successful
      end
    end
    
    context 'when the device is assigned to another user' do
      let(:other_user) { create(:user) }
      
      before do
        device.update!(user: other_user)
        create(:device_assignment, device: device, user: other_user, assigned_at: 1.day.ago)
      end
      
      it 'returns an unauthorized error' do
        unassign
        expect(response.status).to eq(422)
      end
    end
    
    context 'when the device is not assigned to any user' do
      it 'returns an error' do
        unassign
        expect(response.status).to eq(422)
      end
    end
    
    context 'when the user is not authenticated' do
      it 'returns an unauthorized response' do
        post :unassign, params: { device: { serial_number: serial_number } }
        expect(response.status).to eq(401)
      end
    end
  end
end