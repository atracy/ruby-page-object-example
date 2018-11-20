require 'mailinator'

Mailinator.configure do |config|
  config.token = ENV.fetch('MAILINATOR_TOKEN')
end
