module MessenteRails
  module Configuration

    def configure
      yield self
    end

    # Configurable parameters

    mattr_accessor :username
    @@username = nil

    mattr_accessor :password
    @@password = nil

    mattr_accessor :response_as_is
    @@response_as_is = true

  end
end
