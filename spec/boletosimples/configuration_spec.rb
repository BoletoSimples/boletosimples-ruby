# encoding: UTF-8
require 'spec_helper'

RSpec.describe BoletoSimples::Configuration do
  describe 'defaults' do
    before {
      allow(ENV).to receive(:[]).with('BOLETOSIMPLES_ENV').and_return(nil)
      allow(ENV).to receive(:[]).with('BOLETOSIMPLES_APP_ID').and_return(nil)
      allow(ENV).to receive(:[]).with('BOLETOSIMPLES_APP_SECRET').and_return(nil)
      allow(ENV).to receive(:[]).with('BOLETOSIMPLES_ACCESS_TOKEN').and_return(nil)
    }
    subject { BoletoSimples::Configuration.new }
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
      allow(ENV).to receive(:[]).with('BOLETOSIMPLES_ENV').and_return('production')
      allow(ENV).to receive(:[]).with('BOLETOSIMPLES_APP_ID').and_return('app-id')
      allow(ENV).to receive(:[]).with('BOLETOSIMPLES_APP_SECRET').and_return('app-secret')
      allow(ENV).to receive(:[]).with('BOLETOSIMPLES_ACCESS_TOKEN').and_return('access-token')
    }
    subject { BoletoSimples::Configuration.new }
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
