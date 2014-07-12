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

  end
end
