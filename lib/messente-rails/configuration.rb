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

    mattr_accessor :retry_on_fail
    @@retry_on_fail = true

  end
end
