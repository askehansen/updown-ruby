require 'rest-client'
require 'gem_config'
require 'updown/version'
require 'updown/check'
require 'updown/downtime'
require 'updown/call'

module Updown
  include GemConfig::Base

  with_configuration do
    has :api_key, classes: String, default: ENV['UPDOWN_API_KEY'].to_s
  end

end
