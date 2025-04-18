module AssigningError
  class AlreadyUsedOnUser < StandardError
    def initialize(msg = "You cannot reassign a device you've previously returned")
      super
    end
  end

  class AlreadyUsedOnOtherUser < StandardError
    def initialize(msg = "Device is already assigned to another user")
      super
    end
  end
end