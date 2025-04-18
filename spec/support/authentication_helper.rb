module AuthenticationHelper
  def sign_in(user)
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
    controller.instance_variable_set(:@current_user, user)
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelper, type: :controller
end