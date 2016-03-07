require 'json'

module Updown
  Error = Class.new StandardError

  module Call

    def self.resource
      RestClient::Resource.new 'https://updown.io/api/', headers: { 'X-API-KEY' => Updown.configuration.api_key }
    end

    def self.checks
      process { Call.resource['checks'].get }
    end

    def self.downtimes(token, filters={})
      process { Call.resource["checks/#{token}/downtimes"].get(params: filters) }
    end

    def self.create_check(attributes={})
      process { Call.resource['checks'].post(attributes) }
    end

    def self.get_check(token, attributes={})
      process { Call.resource["checks/#{token}"].get(attributes) }
    end

    def self.update_check(token, attributes={})
      process { Call.resource["checks/#{token}"].put(attributes) }
    end

    def self.destroy_check(token)
      process { Call.resource["checks/#{token}"].delete }
    end

    def self.process
      JSON.parse yield
    rescue RestClient::BadRequest, RestClient::Unauthorized, RestClient::ResourceNotFound => e
      result = (JSON.parse(e.response) rescue {})
      raise Updown::Error.new(result['error'] || e.reponse)
    end

  end
end
