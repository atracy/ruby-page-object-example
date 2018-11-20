require 'dotenv'

# Setup build specific environment variables
ENV['APP_ENV'] = (ENV['APP_ENV'] || 'QA').upcase
ENV['ORIGIN'] ||= ('circleci' if ENV['CIRCLECI'])
ENV['BUILD_NUMBER'] ||= ENV['CIRCLE_BUILD_NUM']
ENV['DEVELOPER'] ||= ENV['CIRCLE_USERNAME']
ENV['BRANCH'] ||= ENV['CIRCLE_BRANCH']

# Load environment variables
Dotenv.load("./config/environments/#{ENV['APP_ENV'].downcase}.local",
            './config/environments/global.local',
            "./config/environments/#{ENV['APP_ENV'].downcase}",
            './config/environments/global')
