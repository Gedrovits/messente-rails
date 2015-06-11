require 'webmock/rspec'

# Do not perform any external connections
WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.include WebMock::API
  config.order = :rand

  config.before(:each) do
    WebMock.reset!
  end

  config.after(:each) do
    WebMock.reset!
  end
end


