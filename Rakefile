Dir.glob('lib/tasks/*.rake').each { |r| load r }

# Setup required for Gunter test results reporting
require './gunter_reporter/gunter_reporter.rb'
@gunter_reporter = GunterReporter.new

def run_ludus_web(platform = nil, browser = nil, version = nil, junit_dir = nil)
  task_id = [Time.now.strftime('%s%6N'), platform, browser, version].join('-').gsub(/\s+/, '_')
  environment_variables = { 'TEAM_NAME'   => 'ludus',
                            'platform'    => platform,
                            'browserName' => browser,
                            'version'     => version,
                            'JUNIT_DIR'   => junit_dir,
                            'USESAUCE'    => (platform ? 'true' : nil),
                            'TASK_ID'     => task_id }
  default_spec_files = 'spec/ludus/web/test'
  spec_files = (ARGV.count > 1 ? ARGV.drop(1).join(' ') : default_spec_files)
  exit_status = system(environment_variables, "rspec #{spec_files}")
  @gunter_reporter.submit_results(environment_variables)

  raise 'Tests Failed' unless exit_status
end

desc 'Run tests locally'
task :local_ludus do
  run_ludus_web
end

desc 'Run tests with env vars: platform="Windows 7" browserName="chrome" version="59" USESAUCE="true"'
task :windows_7_chrome_59_ludus do
  run_ludus_web('Windows 7', 'chrome', '59', 'junit_reports/windows_7_chrome_59')
end

desc 'Run tests with env vars: platform="Windows 8.1" browserName="chrome" version="59" USESAUCE="true"'
task :windows_8_1_chrome_59_ do
  run_ludus_web('Windows 8.1', 'chrome', '59', 'junit_reports/windows_8_1_chrome_59')
end

desc 'Run tests with env vars: platform="Windows 10" browserName="chrome" version="59" USESAUCE="true"'
task :windows_10_chrome_59_ludus do
  run_ludus_web('Windows 10', 'chrome', '59', 'junit_reports/windows_10_chrome_59')
end

desc 'Run tests with env vars: platform="Windows 10" browserName="firefox" version="54" USESAUCE="true"'
task :windows_10_firefox_54_ludus do
  run_ludus_web('Windows 10', 'firefox', '54', 'junit_reports/windows_10_firefox54')
end

desc 'Run tests with env vars: platform="OS X 10.11" browserName="safari" version="9.0" USESAUCE="true"'
task :os_x_10_11_safari_9_ludus do
  run_ludus_web('OS X 10.11', 'safari', '9.0', 'junit_reports/os_x_10_11_safari_9')
end

desc 'Run tests with env vars: platform="Windows 8.1" browserName="internet explorer" version="11" USESAUCE="true"'
task :windows_8_1_internet_explorer_11_ludus do
  run_ludus_web('Windows 8.1', 'internet explorer', '11', 'junit_reports/windows_8_1_internet_explorer_11')
end

desc 'Run tests with env vars: platform="Windows 10" browserName="microsoftedge" version="15" USESAUCE="true"'
task :windows_10_microsoftedge_15_ludus do
  run_ludus_web('Windows 10', 'microsoftedge', '15', 'junit_reports/windows_10_edge_13')
end

desc 'Run tests with env vars: platform="macos 10.12" browserName="chrome" version="59" USESAUCE="true"'
task :os_x_10_12_chrome_59_ludus do
  run_ludus_web('macos 10.12', 'chrome', '59', 'junit_reports/os_x_10_12_chrome_59')
end

desc 'Run tests with env vars: platform="macos 10.12" browserName="chrome" version="beta" USESAUCE="true"'
task :os_x_10_12_chrome_beta_ludus do
  run_ludus_web('macos 10.12', 'chrome', 'beta', 'junit_reports/os_x_10_12_chrome_beta')
end

task_list = [
  # :windows_7_chrome_59_ludus,
  :windows_8_1_internet_explorer_11_ludus,
  :windows_10_chrome_59_ludus,
  :windows_10_microsoftedge_15_ludus
  # :windows_10_firefox_54_ludus,
  # :os_x_10_11_safari_9_ludus,
  # :os_x_10_12_chrome_59_ludus,
  # :os_x_10_12_chrome_beta_ludus
]

desc 'Run tests on multiple Sauce Labs platforms'
multitask test_ludus_web: task_list do
  puts 'Saucey: Tested ludus Web'
end
