# encoding: UTF-8

require 'spec_helper'

# Before running this spec again, you need to set environment variable BOLETOSIPLES_CLIENT_CREDENTIALS_TOKEN
RSpec.describe BoletoSimples::Partner::User do
  before {
    BoletoSimples.configure do |c|
      c.access_token = ENV['BOLETOSIMPLES_CLIENT_CREDENTIALS_TOKEN']
    end
  }
  describe 'create', vcr: { cassette_name: 'resources/partner/user/create'} do
    subject { BoletoSimples::Partner::User.create(email: 'user1@example.com') }
    it { expect(subject.id).not_to be_nil }
    it { expect(subject.attributes).to eq({"email"=>"user1@example.com", "id"=>53, "account_type"=>nil, "sex"=>nil, "cpf"=>nil, "address_street_name"=>nil, "address_state"=>nil, "address_neighborhood"=>nil, "address_postal_code"=>nil, "address_number"=>nil, "address_complement"=>nil, "phone_number"=>nil, "withdrawal_period"=>"biweekly", "notification_url"=>nil, "first_name"=>nil, "middle_name"=>nil, "last_name"=>nil, "date_of_birth"=>nil, "business_category"=>nil, "business_subcategory"=>nil, "business_website"=>nil, "business_name"=>nil, "business_legal_name"=>nil, "business_type"=>nil, "business_cnpj"=>nil, "address_city_name"=>nil, "full_name"=>nil, "login_url"=>"https://sandbox.boletosimples.com.br/welcome?email=user1%40example.com&token=Dx6tDtrP_v9_CcDjMRmr", "mother_name"=>nil, "father_name"=>nil, "application_access_token"=>"7f613c03c3ac0ca6744daf1f8b3f02b7586b4124527e82ba86e563709ca7ebad"}) }
  end
end