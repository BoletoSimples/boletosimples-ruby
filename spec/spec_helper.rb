require 'coveralls'
Coveralls.wear!

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'pry'
require 'boletosimples'

if(ENV['BOLETOSIMPLES_ACCESS_TOKEN'].empty?)
  puts "\e[31mWarning: Environment variable BOLETOSIMPLES_ACCESS_TOKEN is not set. Tests will run and pass, but if you delete vcr cassettes you need to set this variable before running tests.\e[0m"
  ENV['BOLETOSIMPLES_ACCESS_TOKEN'] = 'any-token'
end

if(ENV['BOLETOSIMPLES_CLIENT_CREDENTIALS_TOKEN'].empty?)
  puts "\e[31mWarning: Environment variable BOLETOSIMPLES_CLIENT_CREDENTIALS_TOKEN is not set. Tests will run and pass, but if you delete vcr cassettes you need to set this variable before running tests.\e[0m"
  ENV['BOLETOSIMPLES_CLIENT_CREDENTIALS_TOKEN'] = 'any-token'
end

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.order = :random
  Kernel.srand config.seed
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end
  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end
end

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
