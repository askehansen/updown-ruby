module Updown
  class Check
    attr_accessor :token, :enabled, :url, :period, :apdex_t, :published, :uptime, :down, :error, :down_since, :last_check_at, :next_check_at

    def self.all
      Updown::Call.checks.map do |check|
        Check.new check
      end
    end

    def self.create(url, period: 60, published: false)
      Check.new Updown::Call.create_check(url: url, period: period, published: published)
    end

    def initialize(json)
      @token         = json['token']
      @enabled       = json['enabled']
      @url           = json['url']
      @period        = json['period']
      @apdex_t       = json['apdex_t']
      @published     = json['published']
      @uptime        = json['uptime']
      @down          = json['down']
      @error         = json['error']
      @down_since    = json['down_since']
      @last_check_at = json['last_check_at']
      @next_check_at = json['next_check_at']
    end

    def downtimes
      Downtime.find(@token)
    end

    def update(attributes={})
      Check.new Updown::Call.update_check(@token, url: url, period: period, published: published)
    end

    def destroy
      Updown::Call.destroy_check(@token)
      nil
    end
  end
end