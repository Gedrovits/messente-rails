require 'httparty'

class Messente
  include HTTParty
  base_uri 'api2.messente.com'

  SUPPORTED_METHODS = [:send_sms, :get_dlr_response, :get_balance, :prices, :pricelist]

  ERROR_101  = 'Access is restricted, wrong credentials. Check username and password values.'
  ERROR_102  = 'Parameters are wrong or missing. Check that all required parameters are present.'
  ERROR_103  = 'Invalid IP address. The IP address you made the request from, is not in the API settings whitelist.'
  ERROR_104  = 'Country was not found.'
  ERROR_105  = 'This country is not supported.'
  ERROR_106  = 'Invalid format provided. Only json or xml is allowed.'
  ERROR_107  = 'Could not find message with sms_unique_id.'
  ERROR_111  = 'Sender parameter "from" is invalid. You have not activated this sender name from Messente.com'
  FAILED_209 = 'Server failure, try again after a few seconds or try api3.messente.com backup server.'

  attr_accessor :defaults, :credentials, :use_backup_uri, :current_params

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

  # https://messente.com/documentation/sending-sms
  # :text, :from, :to, :time_to_send, 'dlr-url', :charset, :validity, :autoconvert, :udh
  def send_sms(params)
    self.current_params = params
    response = send_request(params)
    smart_response(response.parsed_response)
  end

  # https://messente.com/documentation/delivery-report
  # :sms_unique_id
  def get_dlr_response(params)
    self.current_params = params
    response = send_request(params)
    smart_response(response.parsed_response)
  end

  # https://messente.com/documentation/credits-api
  def get_balance
    response = send_request
    smart_response(response.parsed_response)
  end

  # https://messente.com/documentation/pricing
  # :country, :format
  def prices(params)
    self.current_params = params
    response = send_request(params)
    smart_response(response.parsed_response)
  end

  # https://messente.com/documentation/pricing
  def pricelist
    response = send_request
    smart_response(response.parsed_response)
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
    url = if use_backup_uri === true
            self.use_backup_uri = false
            "#{ self.class.base_uri.gsub('api2', 'api3') }/#{ action }/"
          else
            "/#{ action }/"
          end
    self.class.post(url, { query: safe_query })
  end

  def smart_response(response)
    if response_as_is?
      response
    else
      case response.split(' ').first
      when 'ERROR'
        [false, human_readable_error(response)]
      when 'FAILED'
        if retry_on_fail? && use_backup_uri != false
          self.use_backup_uri = true
          method_name = caller[0].split('`').pop.gsub('\'', '').to_sym
          current_params.blank? ? send(method_name) : send(method_name, current_params)
        else
          self.use_backup_uri = nil
        end
        [false, human_readable_error(response)]
      else
        [true, response]
      end
    end
  end

  def human_readable_error(error)
    safe_error = error.gsub(' ', '_')
    self.class.const_defined?(safe_error) ? self.class.const_get(safe_error) : "#{error} not defined."
  end

  def response_as_is?
    defaults && defaults[:response_as_is]
  end

  def retry_on_fail?
    defaults && defaults[:retry_on_fail]
  end
end
