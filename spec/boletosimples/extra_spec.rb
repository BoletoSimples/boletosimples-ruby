# encoding: UTF-8
require 'spec_helper'

# Before running this spec again, you need to set environment variable BOLETOSIMPLES_ACCESS_TOKEN
RSpec.describe BoletoSimples::Extra do
  context 'not authenticated' do
    before {
      BoletoSimples.configure do |c|
        c.application_id = nil
        c.application_secret = nil
        c.access_token = 'invalid'
      end
    }
    describe 'userinfo', vcr: { cassette_name: 'extra/userinfo/not_authenticated'} do
      subject { BoletoSimples::Extra.userinfo }
      it { expect{subject}.to raise_error(BoletoSimples::ResponseError, "401 GET https://sandbox.boletosimples.com.br/api/v1/userinfo.json?access_token=invalid (Você precisa se logar ou registrar antes de prosseguir.)") }
    end
  end
  context 'authenticated' do
    before {
      BoletoSimples.configure do |c|
        c.application_id = nil
        c.application_secret = nil
      end
    }
    describe 'userinfo', vcr: { cassette_name: 'extra/userinfo/authenticated'} do
      subject { BoletoSimples::Extra.userinfo }
      it { expect(subject).to eq({:id=>53, :login_url=>"https://sandbox.boletosimples.com.br/welcome?email=user1%40example.com&token=Dx6tDtrP_v9_CcDjMRmr", :email=>"user1@example.com", :account_type=>nil, :first_name=>nil, :middle_name=>nil, :last_name=>nil, :full_name=>nil, :cpf=>nil, :date_of_birth=>nil, :mother_name=>nil, :father_name=>nil, :account_level=>2, :phone_number=>nil, :address_street_name=>nil, :address_number=>nil, :address_complement=>nil, :address_neighborhood=>nil, :address_postal_code=>nil, :address_city_name=>nil, :address_state=>nil, :business_name=>nil, :business_cnpj=>nil, :business_legal_name=>nil}) }
    end
  end
end