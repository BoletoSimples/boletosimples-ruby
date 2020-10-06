# frozen_string_literal: true

require 'spec_helper'

# Before running this spec again, you need to set environment variable BOLETOSIPLES_CLIENT_CREDENTIALS_TOKEN
RSpec.describe BoletoSimples::Partner::User do
  before do
    BoletoSimples.configure do |c|
      c.access_token = ENV['BOLETOSIMPLES_CLIENT_CREDENTIALS_TOKEN']
    end
  end
  # ATENÇÃO: Após rodar este teste, edite o vcr_cassette e remova o token do login_url e substitua o application_access_token para xxx
  describe 'create', vcr: { cassette_name: 'resources/partner/user/create' } do
    subject { BoletoSimples::Partner::User.create(email: 'user2@example.com') }
    it { expect(subject.id).not_to be_nil }
    it { expect(subject.response_errors).to eq({}) }
    it { expect(subject.attributes.keys).to eq(%w[email id account_type sex cpf address_street_name address_state address_neighborhood address_postal_code address_number address_complement phone_number withdrawal_period notification_url first_name middle_name last_name date_of_birth business_category business_subcategory business_website business_name business_legal_name business_type business_cnpj address_city_name full_name login_url mother_name father_name application_access_token]) }
  end
end
