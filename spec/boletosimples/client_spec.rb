# encoding: UTF-8

require 'spec_helper'

RSpec.describe BoletoSimples::Client do
  subject(:client) do
    BoletoSimples::Client.new(access_token, user_agent: 'Meu e-Commerce (meuecommerce@example.com)')
  end
  let(:access_token) { '9e616874dbf0674ace28170a748c9258ac1f0f87e0a544441ebffe976645bc09' }

  describe '#userinfo' do
    context 'without authentication', :vcr do
      let(:access_token) { nil }

      it { expect(client.userinfo).to eq('error' => 'Você precisa se logar ou registrar antes de prosseguir.') }
    end

    context 'with authentication', vcr: { cassette_name: 'BoletoSimples_Client/_userinfo/with_authentication'} do
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

  describe '#create_customer' do

    context 'with valid data', vcr: { cassette_name: 'BoletoSimples_Client/_create_customer/with_valid_data' } do
      let(:payload) do
        {
          "id" => 32,
          "mobile_local_code" => nil,
          "mobile_number" => nil,
          "person_type" => "individual",
          "person_name" => "Joao da Silva",
          "cnpj_cpf"=> "012.345.678-90",
          "email" => "cliente@bom.com",
          "address" => "Rua quinhentos",
          "city_name" => "Rio de Janeiro",
          "state" => "RJ",
          "neighborhood" => "bairro",
          "zipcode" => "12312-123",
          "address_number" => "111",
          "address_complement" => "Sala 4",
          "phone_number" => "2112123434"
        }
      end

      def create_customer
        client.create_customer({ 
          "customer" => {
            "person_name" => "Joao da Silva",
            "cnpj_cpf"=> "012.345.678-90",
            "email" => "cliente@bom.com",
            "address" => "Rua quinhentos",
            "city_name" => "Rio de Janeiro",
            "state" => "RJ",
            "neighborhood" => "bairro",
            "zipcode" => "12312-123",
            "address_number" => "111",
            "address_complement" => "Sala 4",
            "phone_number" => "2112123434"
          }
        })
      end

      it { expect(create_customer).to eq(payload) }
    end

    context 'with invalid data', vcr: { cassette_name: 'BoletoSimples_Client/_create_customer/with_invalid_data' } do
      let(:payload) do
        {
          "errors" => {
            "cnpj_cpf" => ["não pode ficar em branco"], 
            "phone_number" => ["é muito curto (mínimo: 10 caracteres)"]
          }
        }
      end

      def create_customer
        client.create_customer({ 
          "customer" => {
            "person_name" => "Joao da Silva",
            "cnpj_cpf"=> "foo",
            "email" => "cliente@bom.com",
            "address" => "Rua quinhentos",
            "city_name" => "Rio de Janeiro",
            "state" => "RJ",
            "neighborhood" => "bairro",
            "zipcode" => "123",
            "address_number" => "111",
            "address_complement" => "Sala 4",
            "phone_number" => "2123434"
          }
        })
      end

      it { expect(create_customer).to eq(payload) }
    end
  end
end
