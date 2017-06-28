# encoding: UTF-8
require 'spec_helper'

RSpec.describe BoletoSimples::Configuration do
  before {
    @last_env = {}
    @last_env['BOLETOSIMPLES_ENV'] = ENV['BOLETOSIMPLES_ENV']
    @last_env['BOLETOSIMPLES_APP_ID'] = ENV['BOLETOSIMPLES_APP_ID']
    @last_env['BOLETOSIMPLES_APP_SECRET'] = ENV['BOLETOSIMPLES_APP_SECRET']
    @last_env['BOLETOSIMPLES_ACCESS_TOKEN'] = ENV['BOLETOSIMPLES_ACCESS_TOKEN']
  }
  after {
    ENV['BOLETOSIMPLES_ENV'] = @last_env['BOLETOSIMPLES_ENV']
    ENV['BOLETOSIMPLES_APP_ID'] = @last_env['BOLETOSIMPLES_APP_ID']
    ENV['BOLETOSIMPLES_APP_SECRET'] = @last_env['BOLETOSIMPLES_APP_SECRET']
    ENV['BOLETOSIMPLES_ACCESS_TOKEN'] = @last_env['BOLETOSIMPLES_ACCESS_TOKEN']
  }
  describe 'defaults' do
    before {
      ENV['BOLETOSIMPLES_ENV'] = nil
      ENV['BOLETOSIMPLES_APP_ID'] = nil
      ENV['BOLETOSIMPLES_APP_SECRET'] = nil
      ENV['BOLETOSIMPLES_ACCESS_TOKEN'] = nil
    }
    subject { BoletoSimples::Configuration.new }
    before { subject.setup_her}
    it { expect(subject.environment).to eq(:sandbox) }
    it { expect(subject.base_uri).to eq('https://sandbox.boletosimples.com.br/api/v1') }
    it { expect(subject.application_id).to be_nil }
    it { expect(subject.application_secret).to be_nil }
    it { expect(subject.access_token).to be_nil }
    it { expect(subject.cache).to be_nil }
    it { expect(subject).not_to be_access_token }
  end
  describe 'environment variables' do
    before {
      ENV['BOLETOSIMPLES_ENV'] = 'production'
      ENV['BOLETOSIMPLES_APP_ID'] = 'app-id'
      ENV['BOLETOSIMPLES_APP_SECRET'] = 'app-secret'
      ENV['BOLETOSIMPLES_ACCESS_TOKEN'] = 'access-token'
    }
    before  { BoletoSimples.configure }
    subject { BoletoSimples.configuration }
    # subject { BoletoSimples::Configuration.new }
    it { expect(subject.environment).to eq(:production) }
    it { expect(subject.base_uri).to eq('https://boletosimples.com.br/api/v1') }
    it { expect(subject.application_id).to eq('app-id') }
    it { expect(subject.application_secret).to eq('app-secret') }
    it { expect(subject.access_token).to eq('access-token') }
    it { expect(subject).to be_access_token }
    describe 'cache' do
      it { expect(subject.cache).to be_nil }
      it { expect(Her::API.default_api.connection.builder.handlers).not_to include(Faraday::HttpCache) }
    end
  end
  describe 'configuration' do
    let(:cache_object) { double('Dalli') }
    before {
      BoletoSimples.configure do |c|
        c.environment = :production
        c.application_id = 'app-id'
        c.application_secret = 'app-secret'
        c.access_token = 'access-token'
        c.cache = cache_object
      end
    }
    subject { BoletoSimples.configuration }
    it { expect(subject.environment).to eq(:production) }
    it { expect(subject.user_agent).to eq("BoletoSimples Ruby Client v#{BoletoSimples::VERSION} (contato@boletosimples.com.br)") }
    it { expect(subject.base_uri).to eq('https://boletosimples.com.br/api/v1') }
    it { expect(subject.application_id).to eq('app-id') }
    it { expect(subject.application_secret).to eq('app-secret') }
    it { expect(subject.access_token).to eq('access-token') }
    describe 'cache' do
      it { expect(subject.cache).to eq(cache_object) }
      it { expect(Her::API.default_api.connection.builder.handlers).to include(Faraday::HttpCache) }
    end
    describe 'client credentials' do
      context 'invalid credentials', vcr: { cassette_name: 'configuration/client_credentials/invalid'} do
        before {
          BoletoSimples.configure do |c|
            c.application_id = 'app-id'
            c.application_secret = 'app-secret'
            c.access_token = nil
          end
        }
        it { expect{subject.client_credentials}.to raise_error(BoletoSimples::ResponseError, "401 POST https://sandbox.boletosimples.com.br/api/v1/oauth2/token (invalid_client)") }
      end
      context 'valid credentials', vcr: { cassette_name: 'configuration/client_credentials/valid'} do
        # Before running this spec again, you need to set environment variable BOLETOSIMPLES_APP_ID and BOLETOSIMPLES_APP_SECRET
        before {
          BoletoSimples.configure do |c|
            c.access_token = nil
          end
        }
        it { expect(subject.client_credentials).to include(:access_token) }
      end
    end
  end
end
