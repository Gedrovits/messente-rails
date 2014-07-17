require 'httparty'

class Messente
  include HTTParty
  base_uri 'api2.messente.com'

  SUPPORTED_METHODS = [:send_sms, :get_dlr_response, :cancel_sms, :get_balance, :prices, :pricelist]

  ERROR_101  = 'Access is restricted, wrong credentials. Check username and password values.'
  ERROR_102  = 'Parameters are wrong or missing. Check that all required parameters are present.'
  ERROR_103  = 'Invalid IP address. The IP address you made the request from, is not in the API settings whitelist.'
  ERROR_104  = 'Country was not found.'
  ERROR_105  = 'This country is not supported.'
  ERROR_106  = 'Invalid format provided. Only json or xml is allowed.'
  ERROR_107  = 'Could not find message with sms_unique_id.'
  ERROR_111  = 'Sender parameter "from" is invalid. You have not activated this sender name from Messente.com'
  FAILED_209 = 'Server failure, try again after a few seconds or try api3.messente.com backup server.'

  attr_accessor :defaults, :credentials, :use_backup_uri

  def initialize(username = nil, password = nil)
    self.defaults = {
      response_as_is: MessenteRails::Configuration.response_as_is,
      retry_on_fail:  MessenteRails::Configuration.retry_on_fail
    }
    self.credentials = {
      username: username || MessenteRails::Configuration.username,
      password: password || MessenteRails::Configuration.password
    }
  end

  # https://messente.com/docs/api/rest/sms/
  def send_sms(params)
    response = send_request(params)
    response_as_is? ? response.smart_response : smart_response(response.smart_response)
  end

  # https://messente.com/docs/api/rest/delivery-request/sync/
  def get_dlr_response(params)
    response = send_request(params)
    response_as_is? ? response.smart_response : smart_response(response.smart_response)
  end

  # https://messente.com/docs/api/rest/cancel-sms/
  def cancel_sms(params)
    response = send_request(params)
    response_as_is? ? response.smart_response : smart_response(response.smart_response)
  end

  # https://messente.com/docs/api/rest/balance/
  def get_balance
    response = send_request
    response_as_is? ? response.smart_response : smart_response(response.smart_response)
  end

  # https://messente.com/docs/api/rest/prices/
  def prices(params)
    response = send_request(params)
    response_as_is? ? response.smart_response : smart_response(response.smart_response)
  end

  # https://messente.com/docs/api/rest/full-pricelist/
  def pricelist
    response = send_request
    response_as_is? ? response.smart_response : smart_response(response.smart_response)
  end

  # Methods below allows us to make all calls above as class methods
  # DRY so we don't need to define all methods again with calling instance from inside

  def self.method_missing(method_name, *arguments, &block)
    if SUPPORTED_METHODS.include? method_name
      self.new.send(method_name, *arguments, &block)
    else
      super
    end
  end

  def self.respond_to_missing?(method_name, include_private = false)
    SUPPORTED_METHODS.include? method_name || super
  end

  private

  def send_request(query = nil)
    action = caller[0].split('`').pop.gsub('\'', '')
    safe_query = query ? credentials.merge(query) : credentials
    self.class.get("#{ self.class.base_uri.gsub('api2', 'api3') if use_backup_uri === true }/#{ action }/", { query: safe_query })
  end

  def smart_response(response)
    case response.split(' ').first
    when 'ERROR', 'FAILED' then human_readable_error(response)
    else response
    end
  end

  def human_readable_error(error)
    self.class.const_defined?(error) ? self.class.const_get(error) : "#{error} not defined."
  end

  def response_as_is?
    defaults && defaults[:response_as_is]
  end

  def retry_on_fail?
    defaults && defaults[:retry_on_fail]
  end
end
