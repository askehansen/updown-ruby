module Updown
  class Downtime
    attr_accessor :error, :started_at, :ended_at, :duration

    def self.find(token, page: 1)
      Updown::Call.downtimes(token, page: page).map do |downtime|
        Downtime.new downtime
      end
    end

    def initialize(json)
      @error      = json['error']
      @started_at = Time.parse(json['started_at']) if json['started_at']
      @ended_at   = Time.parse(json['ended_at']) if json['ended_at']
      @duration   = json['duration']
    end

  end
end