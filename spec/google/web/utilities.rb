class Utilities
  require 'csv'
  include Capybara::DSL
  include Capybara::RSpecMatchers

  def url(app, client = nil)
    @url ||= ENV.fetch([app, client].compact.join('_').upcase + '_URL')
  end

  def username(name)
    ENV.fetch(name.upcase + '_USERNAME')
  end

  def password(name)
    ENV.fetch(name.upcase + '_PASSWORD')
  end

  def metadata(file_path, client_type = nil)
    path = file_path.split('/')
    metadata = path[(path.index('features') + 1)..-1]
               .push(client_type)
               .compact
               .map(&:capitalize)
               .join(' - ')
               .chomp('.rb')
    sauce_metadata = " - #{ENV['platform']} - #{ENV['browserName']} #{ENV['version']}"
    sauce ? metadata << sauce_metadata : metadata
  end

  def microsecond_timestamp
    Time.now.strftime('%s%6N')
  end

  def random_paragraph(timestamp = Time.now.to_i)
    "Timestamp: #{timestamp} - #{Faker::Lorem.paragraph}"
  end

  def switch_to_newly_opened_window
    page.driver.browser.switch_to.window(page.driver.browser.window_handles.last)
  end
end
