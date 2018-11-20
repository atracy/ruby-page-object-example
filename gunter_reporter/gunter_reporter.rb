require './config/environments/dotenv.rb'
require 'securerandom'
require 'uri'
require 'net/http'
require 'json'

class GunterReporter
  def initialize
    clear_results
    build_data
  end

  def clear_results
    FileUtils.rm_r(Dir.glob('tmp/gunter'))
  end

  def submit_results(environment_variables)
    files = Dir.glob("tmp/gunter/#{environment_variables['TASK_ID']}/*")
    files.each do |file|
      report = File.read(file)
      form_data = environment_variables.merge(build_data).merge('report' => report)
      response = submit_result(form_data)
      print_result(response)
    end
  end

  private

  def build_data
    @build_data ||= {
      'BUILD_UUID'   => SecureRandom.uuid,
      'BUILD_NUMBER' => ENV['BUILD_NUMBER'],
      'APP_ENV'      => ENV['APP_ENV'],
      'DEVELOPER'    => ENV['DEVELOPER'],
      'BRANCH'       => ENV['BRANCH'],
      'CI'           => ENV.key?('CI')
    }
  end

  def submit_result(form_data)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == 'https')

    request = Net::HTTP::Post.new(url)
    request.basic_auth('gunter_api', ENV.fetch('GUNTER_PASSWORD'))
    request['content-type'] = 'multipart/form-data'
    request['accept'] = 'APPLICATION/JSON'
    request.set_form_data(form_data)

    http.request(request)
  end

  def url
    @url ||= begin
      if ENV['GUNTER_ENV'].to_s.casecmp?('prod') || ENV['ORIGIN']
        URI('https://gunter-oasis-prod.alamoapp.octanner.io/api/v1/testsuites')
      elsif ENV['GUNTER_ENV'].to_s.casecmp?('dev')
        URI('http://localhost:3000/api/v1/testsuites')
      else
        URI('https://gunter-oasis-stage.alamoapp.octanner.io/api/v1/testsuites')
      end
    end
  end

  def print_result(response)
    if response.code == '201'
      puts "✅  Gunter results: #{JSON.parse(response.body)['url']}"
    else
      open('tmp/gunter/error.html', 'w') { |f| f << response.body }
      puts '⚠️  Gunter results reporting failed. Please report this to Calaway. Thank you.'
    end
  end
end
