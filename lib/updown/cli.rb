require 'colorize'

String.disable_colorization(true) if not STDOUT.isatty

module Updown
  class CLI < Thor

    desc 'status', 'see the status of all your checks'
    def status
      configure_api_key

      Updown::Check.all.each do |check|
        status = if !check.enabled
          ' ---- '.colorize(:light_black)
        elsif check.down
          '[DOWN]'.colorize(:light_red)
        else
          ' [up] '.colorize(:light_green)
        end
        url = if check.ssl_valid == true
          check.url.sub('https', 'https'.colorize(:light_green))
        elsif check.ssl_valid == false
          check.url.sub('https', 'https'.colorize(:light_red))
        else
          check.url
        end
        puts "#{status} #{check.token.colorize(:light_magenta)} #{"—".colorize(:light_black)} #{url}"
      end
    rescue Updown::Error => e
      puts "Error: #{e}"
    end

    desc 'open ID', 'Open the status page of a check'
    def open(token)
      configure_api_key
      
      system "open https://updown.io/#{token}"
    end

    desc 'add URL [PERIOD]', 'add a new check with a default period of 60sec. Available periods are 30/60/120/300/600'
    def add(url, period=60)
      configure_api_key

      check = Updown::Check.create url, period: period
      system "open https://updown.io/#{check.token}"
    rescue Updown::Error => e
      puts "Error: #{e}"
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