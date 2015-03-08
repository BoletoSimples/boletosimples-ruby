# encoding: UTF-8

require 'spec_helper'

# Before running this spec again, you need to set environment variable BOLETOSIMPLES_ACCESS_TOKEN
RSpec.describe BoletoSimples::Customer do
  before {
    BoletoSimples.configure do |c|
      c.application_id = nil
      c.application_secret = nil
    end
  }
  describe 'methods' do
    before {
      VCR.use_cassette('resources/customer/create/valid') do
        @customer = BoletoSimples::Customer.create({
          person_name: "Maria José",
          cnpj_cpf: "811.536.151-85",
          email: "cliente@example.com",
          address: "Rua quinhentos",
          city_name: "Rio de Janeiro",
          state: "RJ",
          neighborhood: "bairro",
          zipcode: "12312-123",
          address_number: "111",
          address_complement: "Sala 4",
          phone_number: "2112123434"
        })
      end
    }
    describe 'create' do
      context 'valid parameters' do
        subject { @customer }
        it { expect(subject).to be_a_kind_of(BoletoSimples::Customer) }
        it { expect(subject.response_errors).to eq({}) }
        it { expect(subject.attributes.keys).to match_array(["person_name","cnpj_cpf","email","address","city_name","state","neighborhood","zipcode","address_number","address_complement","phone_number","mobile_number","person_type","mobile_local_code","created_via_api","id"]) }
      end
      context 'invalid parameters' do
        context 'empty bank_billet' do
          subject {
            VCR.use_cassette('resources/customer/create/invalid_root') do
              BoletoSimples::Customer.create({})
            end
          }
          it { expect(subject.response_errors).to eq({:customer=>["não pode ficar em branco"]}) }
        end
        context 'invalid params' do
          subject {
            VCR.use_cassette('resources/customer/create/invalid_params') do
              BoletoSimples::Customer.create({person_name: ''})
            end
          }
          it { expect(subject.response_errors).to eq({:person_name=>["não pode ficar em branco"], :cnpj_cpf=>["não pode ficar em branco"], :zipcode=>["não pode ficar em branco"]}) }
        end
      end
    end
    describe 'find', vcr: { cassette_name: 'resources/customer/find'} do
      subject { BoletoSimples::Customer.find(@customer.id) }
      it { expect(subject).to be_a_kind_of(BoletoSimples::Customer) }
    end
    describe 'all', vcr: { cassette_name: 'resources/customer/all'} do
      subject { BoletoSimples::Customer.all }
      it { expect(subject.first).to be_a_kind_of(BoletoSimples::Customer) }
    end
  end
end