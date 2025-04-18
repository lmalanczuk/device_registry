class ApplicationController < ActionController::API
  attr_reader :current_user
  
  def authenticate_user!
    api_key = ApiKey.find_by(token: request.session[:token])
    @current_user = api_key&.bearer
    
    if @current_user.nil?
      head :unauthorized
    end
  end
end