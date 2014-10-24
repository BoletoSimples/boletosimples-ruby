# encoding: UTF-8

require 'spec_helper'

RSpec.describe BoletoSimples::Client do

  describe '#userinfo' do
    subject(:client) do
      BoletoSimples::Client.new(access_token, user_agent: 'Meu e-Commerce (meuecommerce@example.com)')
    end

    context 'without authentication', :vcr do
      let(:access_token) { nil }

      it { expect(client.userinfo).to eq('error' => 'Você precisa se logar ou registrar antes de prosseguir.') }
    end

    context 'with authentication', vcr: { cassette_name: 'BoletoSimples_Client/_userinfo/with_authentication'} do
      let(:access_token) { '9e616874dbf0674ace28170a748c9258ac1f0f87e0a544441ebffe976645bc09' }
      let(:json_keys) do
        ["account_level", "account_type",
         "address_city_name", "address_complement",
         "address_neighborhood", "address_number",
         "address_postal_code", "address_state",
         "address_street_name", "business_cnpj",
         "business_legal_name", "business_name",
         "cpf", "date_of_birth", "email", "father_name",
         "first_name", "full_name", "id", "last_name",
         "login_url", "middle_name", "mother_name" , "phone_number"
        ]
      end

      it { expect(client.userinfo['email']).to eq('marciojunior1991@gmail.com') }
      it { expect(client.userinfo['account_level']).to eq(2) }
      it { expect(client.userinfo.keys).to match_array(json_keys) }
    end
  end
end
