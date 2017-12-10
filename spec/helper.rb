require 'updown'
require 'vcr'

# Replace this API key by your key when writing new specs.
# WARNING: Your API key will then be shown in the cassettes files.
# Don't forget to replace it throughout all the project before pushing to GitHub.
Updown.configuration.api_key = 'ePXULY6xLJ5XixzUSybU'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
end
