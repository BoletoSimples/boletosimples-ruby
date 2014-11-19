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
        })
      end

      it { expect(create_customer).to eq(payload) }
    end
  end

  describe '#customers', vcr: { cassette_name: 'BoletoSimples_Client/_customers' } do
    let(:customer) do
       {"id"=>32,
         "city_name" => "Rio de Janeiro",
         "person_name" => "Joao da Silva",
         "address" => "Rua quinhentos",
         "address_complement" => "Sala 4",
         "address_number" => "111",
         "mobile_number" => nil,
         "cnpj_cpf" => "012.345.678-90",
         "email" => "cliente@bom.com",
         "neighborhood" => "bairro",
         "person_type" => "individual",
         "phone_number" => "2112123434",
         "zipcode" => "12312-123",
         "mobile_local_code" => nil,
         "state" => "RJ"
       }
    end

    it { expect(client.customers).to eq([customer]) }
  end

  describe '#customer' do

    context "not found", vcr: { cassette_name: 'BoletoSimples_Client/_customer/not_found' } do
      it { expect(client.customer(42)).to eq({"status"=>"404", "error"=>"Not Found"}) }
    end

    context "existing customer", vcr: { cassette_name: 'BoletoSimples_Client/_customer/existing_customer' } do
      let(:customer) do
         {
           "id"=>32,
           "city_name" => "Rio de Janeiro",
           "person_name" => "Joao da Silva",
           "address" => "Rua quinhentos",
           "address_complement" => "Sala 4",
           "address_number" => "111",
           "mobile_number" => nil,
           "cnpj_cpf" => "012.345.678-90",
           "email" => "cliente@bom.com",
           "neighborhood" => "bairro",
           "person_type" => "individual",
           "phone_number" => "2112123434",
           "zipcode" => "12312-123",
           "mobile_local_code" => nil,
           "state" => "RJ"
         }
      end

      it { expect(client.customer(32)).to eq(customer) }
    end
  end

  describe '#create_bank_billet' do

    context 'with valid data', vcr: { cassette_name: 'BoletoSimples_Client/_create_bank_billet/with_valid_data' } do
      let(:payload) do
        {
          "amount" => 9.01,
          "created_via_api" => true,
          "customer_address" => "Rua quinhentos",
          "customer_address_complement" => "Sala 4",
          "customer_address_number" => "111",
          "customer_city_name" => "Rio de Janeiro",
          "customer_cnpj_cpf" => "012.345.678-90",
          "customer_email" => "cliente@bom.com",
          "customer_neighborhood" => "Sao Francisco",
          "customer_person_name" => "Joao da Silva",
          "customer_person_type" => "individual",
          "customer_phone_number" => "2112123434",
          "customer_state" => "RJ",
          "customer_zipcode" => "12312-123",
          "description" => "Despesas do contrato 0012",
          "expire_at" => "2014-01-01",
          "id" => 113,
          "notification_url" => "http://example.com.br/notify",
          "paid_amount" => 0.0,
          "paid_at" => nil,
          "send_email_on_creation" => nil,
          "shorten_url" => nil,
          "status" => "generating"
        }
      end

      def create_bank_billet
        client.create_bank_billet({
          "amount" => 9.01,
          "customer_address" => 'Rua quinhentos',
          "customer_address_complement" => 'Sala 4',
          "customer_address_number" => '111',
          "customer_city_name" => 'Rio de Janeiro',
          "customer_cnpj_cpf" => '012.345.678-90',
          "customer_email" => 'cliente@bom.com',
          "customer_neighborhood" => 'Sao Francisco',
          "customer_person_name" => 'Joao da Silva',
          "customer_person_type" => 'individual',
          "customer_phone_number" => '2112123434',
          "customer_state" => 'RJ',
          "customer_zipcode" => '12312-123',
          "description" => 'Despesas do contrato 0012',
          "expire_at" => '2014-01-01',
          "notification_url" => 'http://example.com.br/notify'
        })
      end

      it { expect(create_bank_billet).to eq(payload) }
    end

    context 'with invalid data', vcr: { cassette_name: 'BoletoSimples_Client/_create_bank_billet/with_invalid_data' } do
      let(:payload) do
        {
          "errors"=> {
            "customer_cnpj_cpf" => ["não pode ficar em branco"],
            "customer_email" => ["não é válido"],
            "customer" => [
              {
                "cnpj_cpf" => ["não pode ficar em branco"],
                "phone_number" => ["é muito curto (mínimo: 10 caracteres)"],
                "email" => ["não é válido"]
              }
            ],
            "amount"=>["deve ser menor ou igual a 10"]
          }
        }
      end

      def create_bank_billet
        client.create_bank_billet({
          "amount" => 19.01,
          "customer_address" => 'Rua quinhentos',
          "customer_address_complement" => 'Sala 4',
          "customer_address_number" => '111',
          "customer_city_name" => 'Rio de Janeiro',
          "customer_cnpj_cpf" => '34567890',
          "customer_email" => 'cliente',
          "customer_neighborhood" => 'Sao Francisco',
          "customer_person_name" => 'Joao da Silva',
          "customer_person_type" => 'individual',
          "customer_phone_number" => '123434',
          "customer_state" => 'RJ',
          "customer_zipcode" => '12312',
          "description" => 'Despesas do contrato 0012',
          "expire_at" => '2014-01-01',
          "notification_url" => 'http://example.com.br/notify'
        })
      end

      it { expect(create_bank_billet).to eq(payload) }
    end
  end

  describe '#bank_billets', vcr: { cassette_name: 'BoletoSimples_Client/_bank_billets' } do
    let(:bank_billet) do
      {
        "id"=>113,
        "expire_at"=>"2014-01-01",
        "paid_at"=>nil,
        "description"=>"Despesas do contrato 0012",
        "status"=>"opened",
        "shorten_url"=>"http://staging.bole.to/nhhvauui",
        "customer_person_type"=>"individual",
        "customer_person_name"=>"Joao da Silva",
        "customer_cnpj_cpf"=>"012.345.678-90",
        "customer_address"=>"Rua quinhentos",
        "customer_state"=>"RJ",
        "customer_neighborhood"=>"Sao Francisco",
        "customer_zipcode"=>"12312-123",
        "customer_address_number"=>"111",
        "customer_address_complement"=>"Sala 4",
        "customer_phone_number"=>"2112123434",
        "customer_email"=>"cliente@bom.com",
        "notification_url"=>"http://example.com.br/notify",
        "send_email_on_creation"=>nil,
        "created_via_api"=>true,
        "customer_city_name"=>"Rio de Janeiro",
        "paid_amount"=>0.0,
        "amount"=>9.01
      }
    end

    it { expect(client.bank_billets).to eq([bank_billet]) }
  end

  describe '#bank_billet' do
    context 'not found', vcr: { cassette_name: 'BoletoSimples_Client/_bank_billet/not_found' } do
      it { expect(client.bank_billet(4324)).to eq({ "status"=>"404", "error"=>"Not Found" }) }
    end

    context 'existing bank billet', vcr: { cassette_name: 'BoletoSimples_Client/_bank_billet/existing_bank_billet' } do
      let(:bank_billet) do
        {
          "id"=>113,
          "expire_at"=>"2014-01-01",
          "paid_at"=>nil,
          "description"=>"Despesas do contrato 0012",
          "status"=>"opened",
          "shorten_url"=>"http://staging.bole.to/nhhvauui",
          "customer_person_type"=>"individual",
          "customer_person_name"=>"Joao da Silva",
          "customer_cnpj_cpf"=>"012.345.678-90",
          "customer_address"=>"Rua quinhentos",
          "customer_state"=>"RJ",
          "customer_neighborhood"=>"Sao Francisco",
          "customer_zipcode"=>"12312-123",
          "customer_address_number"=>"111",
          "customer_address_complement"=>"Sala 4",
          "customer_phone_number"=>"2112123434",
          "customer_email"=>"cliente@bom.com",
          "notification_url"=>"http://example.com.br/notify",
          "send_email_on_creation"=>nil,
          "created_via_api"=>true,
          "customer_city_name"=>"Rio de Janeiro",
          "paid_amount"=>0.0,
          "amount"=>9.01
        }
      end

      it { expect(client.bank_billet(113)).to eq(bank_billet) }
    end
  end

  describe '#transactions', vcr: { cassette_name: 'BoletoSimples_Client/_transactions' } do
    let(:credit_tx) do
      {
        "id"=>15,
        "amount"=>9.01,
        "created_at"=>"2014-11-03",
        "description"=>"Boleto Bancário 113",
        "kind"=>"credit",
        "processed_at"=>nil,
        "sent_at"=>nil,
        "status"=>"unprocessed",
        "credit_at"=>"2014-11-06"
      }
    end

    let(:fee_tx) do
      {
        "id"=>16,
        "amount"=>-5.0,
        "created_at"=>"2014-11-03",
        "description"=>"Boleto Bancário 113",
        "kind"=>"fee",
        "processed_at"=>nil,
        "sent_at"=>nil,
        "status"=>"unprocessed",
        "credit_at"=>"2014-11-06"
      }
    end

    it { expect(client.transactions).to match_array([fee_tx, credit_tx]) }
  end
end
