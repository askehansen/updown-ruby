module Updown
  class Call

    def self.resource
      RestClient::Resource.new 'https://updown.io/api/', headers: { 'X-API-KEY' => Updown.configuration.api_key }
    end

    def self.checks
      JSON.parse Call.resource['checks'].get
    end

    def self.downtimes(token)
      JSON.parse Call.resource["checks/#{token}/downtimes"].get
    end

    def self.create_check(attributes={})
      JSON.parse Call.resource['checks'].post(attributes)
    end

    def self.update_check(token, attributes={})
      JSON.parse Call.resource["checks/#{token}"].put(attributes)
    end

    def self.destroy_check(token)
      JSON.parse Call.resource["checks/#{token}"].delete
    end

  end
end