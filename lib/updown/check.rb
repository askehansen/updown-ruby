require 'time'

module Updown
  class Check
    attr_accessor :token, :url, :alias, :last_status, :uptime, :down, :down_since, :error, :period, :apdex_t, :enabled, :published, :last_check_at, :next_check_at, :ssl_tested_at, :ssl_valid, :ssl_error, :metrics

    def self.all
      Updown::Call.checks.map do |check|
        Check.new check
      end
    end

    def self.create(url, attributes = {})
      Check.new Updown::Call.create_check(attributes.merge(url: url))
    end

    def self.get(token, attributes = {})
      Check.new Updown::Call.get_check(token, attributes)
    end

    def initialize(json)
      @token         = json['token']
      @url           = json['url']
      @alias         = json['alias']
      @last_status   = json['last_status']
      @enabled       = json['enabled']
      @period        = json['period']
      @apdex_t       = json['apdex_t']
      @published     = json['published']
      @uptime        = json['uptime']
      @down          = json['down']
      @error         = json['error']
      @metrics       = json['metrics']
      @down_since    = Time.parse(json['down_since']) if json['down_since']
      @last_check_at = Time.parse(json['last_check_at']) if json['last_check_at']
      @next_check_at = Time.parse(json['next_check_at']) if json['next_check_at']
      if ssl = json['ssl']
        @ssl_tested_at = Time.parse(ssl['tested_at']) if ssl['tested_at']
        @ssl_valid     = ssl['valid']
        @ssl_error     = ssl['error']
      end
    end

    def downtimes page: 1
      Downtime.find(@token, page: page)
    end

    def get_metrics filters = {}
      Updown::Call.metrics(@token, filters)
    end

    def update(attributes={})
      Check.new Updown::Call.update_check(@token, attributes)
    end

    def destroy
      Updown::Call.destroy_check(@token)['deleted']
    end
  end
end
