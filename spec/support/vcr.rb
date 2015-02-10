require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.before_record do |i|
    i.response.body.force_encoding('UTF-8')
  end
  c.filter_sensitive_data('BOLETOSIMPLES_APP_ID') { ENV['BOLETOSIMPLES_APP_ID'] }
  c.filter_sensitive_data('BOLETOSIMPLES_APP_SECRET') { ENV['BOLETOSIMPLES_APP_SECRET'] }
  c.filter_sensitive_data('BOLETOSIMPLES_ACCESS_TOKEN') { ENV['BOLETOSIMPLES_ACCESS_TOKEN'] }
  c.filter_sensitive_data('BOLETOSIMPLES_CLIENT_CREDENTIALS_TOKEN') { ENV['BOLETOSIMPLES_CLIENT_CREDENTIALS_TOKEN'] }
end
