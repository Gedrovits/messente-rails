require 'httparty'

class Messente
  include HTTParty
  base_uri 'api2.messente.com'

  ERROR_101  = 'Access is restricted, wrong credentials. Check username and password values.'
  ERROR_102  = 'Parameters are wrong or missing. Check that all required parameters are present.'
  ERROR_103  = 'Invalid IP address. The IP address you made the request from, is not in the API settings whitelist.'
  ERROR_111  = 'Sender parameter "from" is invalid. You have not activated this sender name from Messente.com'
  FAILED_209 = 'Server failure, try again after a few seconds or try api3.messente.com backup server.'

  class << self
    # https://messente.com/docs/api/rest/sms/
    def send_sms(mobile, message, backup_uri = false)
      action = '/send_sms/'
      query  = credentials.merge({ to: mobile, text: message })
      url    = backup_uri ? self.backup_uri + action : action

      response = get(url, { query: query })
      return false unless ok? response

      case response.parsed_response
        when 'ERROR 101'  then ERROR_101
        when 'ERROR 102'  then ERROR_102
        when 'ERROR 103'  then ERROR_103
        when 'ERROR 111'  then ERROR_111
        when 'FAILED 209' then backup_uri ? false : send_sms(mobile, message, true)
        else
          # TODO: Should we save somewhere unique SMS ID?
          # unique_sms_id = response.parsed_response.split(' ').second
          true
      end
    end

    # https://messente.com/docs/api/rest/delivery-request/sync/
    def get_dlr_response(sms_unique_id, backup_uri = false)
      action = '/get_dlr_response/'
      query  = credentials.merge({ sms_unique_id: sms_unique_id })
      url    = backup_uri ? self.backup_uri + action : action

      response = get(url, { query: query })
      return false unless ok? response

      case response.parsed_response
        when 'ERROR 101'  then ERROR_101
        when 'ERROR 102'  then ERROR_102
        when 'FAILED 209' then backup_uri ? false : get_dlr_response(sms_unique_id, true)
        else response.parsed_response.split(' ').second.downcase
      end
    end

    # https://messente.com/docs/api/rest/cancel-sms/
    def cancel_sms(sms_unique_id, backup_uri = false)
      action = '/cancel_sms/'
      query  = credentials.merge({ sms_unique_id: sms_unique_id })
      url    = backup_uri ? self.backup_uri + action : action

      response = get(url, { query: query })
      return false unless ok? response

      case response.parsed_response
        when 'ERROR 107'  then 'Could not find message with sms_unique_id.'
        when 'FAILED 209' then backup_uri ? false : cancel_sms(sms_unique_id, true)
        else true
      end
    end

    # https://messente.com/docs/api/rest/balance/
    def get_balance(backup_uri = false)
      action = '/get_balance/'
      url    = backup_uri ? self.backup_uri + action : action

      response = get(url, { query: credentials })
      return false unless ok? response

      case response.parsed_response
        when 'ERROR 101'  then ERROR_101
        when 'ERROR 102'  then ERROR_102
        when 'FAILED 209' then backup_uri ? false : get_balance(true)
        else response.parsed_response.split(' ').second
      end
    end

    # https://messente.com/docs/api/rest/prices/
    def prices(country, format = 'json', backup_uri = false)
      action = '/prices/'
      query  = credentials.merge({ country: country, format: format })
      url    = backup_uri ? self.backup_uri + action : action

      response = get(url, { query: query })
      return false unless ok? response

      case response.parsed_response
        when 'ERROR 101'  then ERROR_101
        when 'ERROR 102'  then ERROR_102
        when 'ERROR 103'  then 'IP address not allowed.'
        when 'ERROR 104'  then 'Country was not found.'
        when 'ERROR 105'  then 'This country is not supported.'
        when 'ERROR 106'  then 'Invalid format provided. Only json or xml is allowed.'
        when 'FAILED 209' then backup_uri ? false : prices(country, 'json', true)
        else response.parsed_response
      end
    end

    # https://messente.com/docs/api/rest/full-pricelist/
    def pricelist(backup_uri = false)
      action = '/pricelist/'
      url    = backup_uri ? self.backup_uri + action : action

      response = get(url, { query: credentials })
      return false unless ok? response

      case response.parsed_response
        when 'ERROR 101'  then ERROR_101
        when 'ERROR 102'  then ERROR_102
        when 'ERROR 103'  then 'IP address not allowed.'
        when 'FAILED 209' then backup_uri ? false : pricelist(true)
        else response.parsed_response
      end
    end

    private

    def credentials
      { username: MessenteRails::Configuration.username,
        password: MessenteRails::Configuration.password }
    end

    def backup_uri
      base_uri.gsub('api2', 'api3')
    end

    def ok?(response)
      response.code == 200
    end
  end
end
