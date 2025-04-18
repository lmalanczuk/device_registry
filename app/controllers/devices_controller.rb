# frozen_string_literal: true

class DevicesController < ApplicationController
  before_action :authenticate_user!, only: %i[assign unassign]
  
  def assign
    AssignDeviceToUser.new(
      requesting_user: @current_user,
      serial_number: params[:device][:serial_number],
      new_device_owner_id: params[:new_owner_id]
    ).call
    head :ok
  rescue RegistrationError::Unauthorized
    render json: { error: 'Unauthorized' }, status: 422
  rescue StandardError => e
    render json: { error: e.message }, status: 422
  end

  def unassign
    ReturnDeviceFromUser.new(
      user: @current_user,
      serial_number: params[:device][:serial_number]
    ).call
    head :ok
  rescue ReturnError::Unauthorized
    render json: { error: 'Unauthorized' }, status: 422
  rescue StandardError => e
    render json: { error: e.message }, status: 422
  end

  private

  def device_params
    params.require(:device).permit(:serial_number)
  end
end