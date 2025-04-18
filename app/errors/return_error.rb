module ReturnError
  class NotAssigned < StandardError
    def initialize(msg = "Device is not currently assigned to any user")
      super
    end
  end

  class Unauthorized < StandardError
    def initialize(msg = "Only the user who has the device assigned can return it")
      super
    end
  end
end