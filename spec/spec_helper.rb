require './config/environments/dotenv.rb'
require 'sauce_whisk'
require 'capybara/rspec'
require 'capybara'
require 'rspec'
require 'json'
require 'eyes_selenium'
require 'rspec/expectations'
require 'require_all'
require 'net/https'
require 'colorize'
require 'rspec/retry'
require 'oauth2'
require 'selenium-webdriver'
require 'pry'
require 'pry-byebug'
require 'faker'
require 'google/web/utilities'
require 'google/web/google'
require 'octanner/web/utilities'
require 'octanner/web/octanner'
require_rel '/google/web/helper/'
require_rel '/octanner/web/helper/'
Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |f| require f }

usesauce = ENV.fetch('USESAUCE', false)

Capybara.configure do |config|
  config.run_server = true
  config.default_max_wait_time = 15
  config.match = :prefer_exact
  config.ignore_hidden_elements = true
  config.visible_text_only = true
  config.automatic_reload = true
  config.default_driver = :selenium
end

RSpec.configure do |config|
  config.before do |scenario|
    if usesauce
      puts 'Using Sauce'
      Capybara.register_driver :selenium do |app|
        capabilities = {
          version:          ENV.fetch('version'),
          browserName:      ENV.fetch('browserName'),
          platform:         ENV.fetch('platform'),
          build:            [ENV['TEAM_NAME'],
                             ENV['BUILD_NUMBER'],
                             ENV['APP_ENV'],
                             ENV['DEVELOPER']].compact.join(' - '),
          screenResolution: '1600x1200',
          name:             scenario.full_description
        }
        url = "https://#{ENV.fetch('SAUCE_USERNAME')}:#{ENV.fetch('SAUCE_ACCESS_KEY')}" \
        '@ondemand.saucelabs.com:443/wd/hub'.strip

        Capybara::Selenium::Driver.new(app,
                                       browser: :remote,
                                       url: url,
                                       desired_capabilities: capabilities)
      end

      # Capybara.current_driver = :remote
      jobname = scenario.full_description
      Capybara.session_name = [jobname, ENV['platform'], ENV['browserName'],
                               ENV['version']].join(' - ')

      @driver = Capybara.current_session.driver

      # Output sessionId and jobname to std out for Sauce OnDemand Plugin to display embeded results
      @session_id = @driver.browser.session_id
      puts "SauceOnDemandSessionID=#{@session_id} job-name=#{jobname}"
    else
      puts 'Using Selenium'
      browser = ENV.fetch('BROWSER', :chrome).downcase.to_sym
      Capybara.register_driver :selenium do |app|
        Capybara::Selenium::Driver.new(app, browser: browser)
      end
      @driver = Capybara.current_session.driver
    end
  end

  config.include Capybara::DSL
  config.include Capybara::RSpecMatchers
  config.formatter = :documentation
  config.verbose_retry = true
  config.display_try_failure_messages = true
  config.default_retry_count = 2
  config.default_sleep_interval = 2
  config.filter_run_excluding broken: true
  config.filter_run_excluding sauce: false if usesauce
  ignore_app = Hash[ENV.fetch('APP_ENV', 'qa').downcase.to_sym, false]
  config.filter_run_excluding ignore_app
  config.expect_with :rspec do |c|
    c.syntax = %i[should expect]
  end
  config.example_status_persistence_file_path = 'tmp/rspec/example_status_persistence_file_path.txt'

  config.after do |scenario|
    # Save screenshot on failure
    if scenario.exception
      screenshot_directory = 'tmp/screenshots'
      FileUtils.mkdir_p(screenshot_directory)
      filename = Time.now.strftime('%m-%d_%H:%M:%S') + scenario.id.gsub(/\W/, '_')
      page.save_screenshot("#{screenshot_directory}/#{filename}.png")
    end

    @driver.quit
    if usesauce
      Capybara.use_default_driver
      if scenario.exception
        SauceWhisk::Jobs.fail_job @session_id
      else
        SauceWhisk::Jobs.pass_job @session_id
      end
    end
  end
end
