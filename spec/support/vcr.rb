# frozen_string_literal: true

require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.ignore_hosts 'codeclimate.com'
  c.before_record do |i|
    i.response.body.force_encoding('UTF-8')
  end
  c.filter_sensitive_data('BOLETOSIMPLES_API_TOKEN') { ENV['BOLETOSIMPLES_API_TOKEN'] }
end
