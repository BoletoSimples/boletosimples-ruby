# encoding: utf-8
require 'spec_helper'

# encoding: UTF-8
require 'spec_helper'

RSpec.describe BoletoSimples::Configuration do
  describe 'defaults' do
    subject { BoletoSimples::Configuration.new }
    it { expect(subject.environment).to eq(:sandbox) }
    it { expect(subject.base_uri).to eq('https://sandbox.boletosimples.com.br/api/v1') }
    it { expect(subject.user_agent).to eq("BoletoSimples Ruby Client v#{BoletoSimples::VERSION}") }
    it { expect(subject.application_id).to be_nil }
    it { expect(subject.application_secret).to be_nil }
    it { expect(subject.access_token).to be_nil }
  end
  describe 'configuration' do
    before {
      BoletoSimples.configure do |c|
        c.environment = :production
        c.application_id = 'app-id'
        c.application_secret = 'app-secret'
        c.access_token = 'access-token'
      end
    }
    subject { BoletoSimples.configuration }
    it { expect(subject.environment).to eq(:production) }
    it { expect(subject.base_uri).to eq('https://boletosimples.com.br/api/v1') }
    it { expect(subject.application_id).to eq('app-id') }
    it { expect(subject.application_secret).to eq('app-secret') }
    it { expect(subject.access_token).to eq('access-token') }
  end
end
