module RegistrationError
  class Unauthorized < StandardError
    def initialize(msg = "You can only assign devices to yourself")
      super
    end
  end
end