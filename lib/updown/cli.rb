module Updown
  class CLI < Thor

    desc 'status', 'see the status of all your checks'
    def status
      configure_api_key

      Updown::Check.all.each do |check|
        status = check.down ? 'DOWN' : 'up'
        puts "[#{status}] #{check.url}"
      end
    end

    desc 'add URL [PERIOD]', 'add a new check'
    def add(url, period=60)
      configure_api_key

      check = Updown::Check.create url, period: period
      system "open https://updown.io/#{check.token}"
    end

    desc 'configure API_KEY', 'set your updown.io api key'
    def configure(api_key)
      config = read_config
      config['api_key'] = api_key

      write_config config
    end

    private

    CONFIG_FILE = File.expand_path('~/.updown')

    def read_config
      if File.exist? CONFIG_FILE
        YAML.load File.read(CONFIG_FILE)
      else
        {}
      end
    end

    def write_config(config)
      File.write CONFIG_FILE, config.to_yaml
    end

    def configure_api_key
      if api_key = read_config['api_key']
        Updown.configuration.api_key = api_key
      else
        abort "no api key configured!\nrun `updown configure API_KEY`"
      end
    end

  end
end