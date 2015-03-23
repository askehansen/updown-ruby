module Updown
  class Downtime
    attr_accessor :error, :started_at, :ended_at, :duration

    def self.find(token)
      Updown::Call.downtimes(token).map do |downtime|
        Downtime.new downtime
      end
    end

    def initialize(json)
      @error      = json['error']
      @started_at = json['started_at']
      @ended_at   = json['ended_at']
      @duration   = json['duration']
    end

  end
end