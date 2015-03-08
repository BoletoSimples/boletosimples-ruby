# encoding: UTF-8

require 'spec_helper'

# Before running this spec again, you need to set environment variable BOLETOSIMPLES_ACCESS_TOKEN
RSpec.describe BoletoSimples::BankBillet do
  before {
    BoletoSimples.configure do |c|
      c.application_id = nil
      c.application_secret = nil
    end
  }
  describe 'methods' do
    before {
      VCR.use_cassette('resources/bank_billet/create/valid') do
        @bank_billet = BoletoSimples::BankBillet.create({
          amount: 9.01,
          description: 'Despesas do contrato 0012',
          expire_at: '2014-01-01',
          customer_address: 'Rua quinhentos',
          customer_address_complement: 'Sala 4',
          customer_address_number: '111',
          customer_city_name: 'Rio de Janeiro',
          customer_cnpj_cpf: '012.345.678-90',
          customer_email: 'cliente@example.com',
          customer_neighborhood: 'Sao Francisco',
          customer_person_name: 'Joao da Silva',
          customer_person_type: 'individual',
          customer_phone_number: '2112123434',
          customer_state: 'RJ',
          customer_zipcode: '12312-123',
          notification_url: 'http://example.com.br/notify'
        })
      end
    }
    describe 'create' do
      context 'valid parameters' do
        subject { @bank_billet }
        it { expect(subject).to be_a_kind_of(BoletoSimples::BankBillet) }
        it { expect(subject.response_errors).to eq({}) }
        it { expect(subject.attributes.keys).to match_array(["amount","description","expire_at","customer_address","customer_address_complement","customer_address_number","customer_city_name","customer_cnpj_cpf","customer_email","customer_neighborhood","customer_person_name","customer_person_type","customer_phone_number","customer_state","customer_zipcode","notification_url","id","paid_at","status","shorten_url","send_email_on_creation","created_via_api","paid_amount"]) }
      end
      context 'invalid parameters' do
        context 'empty bank_billet' do
          subject {
            VCR.use_cassette('resources/bank_billet/create/invalid_root') do
              BoletoSimples::BankBillet.create({})
            end
          }
          it { expect(subject.response_errors).to eq({:bank_billet=>["não pode ficar em branco"]}) }
        end
        context 'invalid params' do
          subject {
            VCR.use_cassette('resources/bank_billet/create/invalid_params') do
              BoletoSimples::BankBillet.create({amount: 9.1})
            end
          }
          it { expect(subject.response_errors).to eq({:expire_at=>["não pode ficar em branco", "não é uma data válida"], :customer_person_name=>["não pode ficar em branco"], :customer_cnpj_cpf=>["não pode ficar em branco"], :description=>["não pode ficar em branco"], :customer_zipcode=>["não pode ficar em branco"]}) }
        end
      end
    end
    describe 'find', vcr: { cassette_name: 'resources/bank_billet/find'} do
      subject { BoletoSimples::BankBillet.find(@bank_billet.id) }
      it { expect(subject).to be_a_kind_of(BoletoSimples::BankBillet) }
    end
    describe 'cancel' do
      context 'success', vcr: { cassette_name: 'resources/bank_billet/cancel/success'} do
        subject { BoletoSimples::BankBillet.find(@bank_billet.id) }
        it { expect(subject.cancel).to be_truthy }
      end
      context 'failure', vcr: { cassette_name: 'resources/bank_billet/cancel/failure'} do
        subject { BoletoSimples::BankBillet.find(863) }
        it { expect(subject.cancel).to be_falsy }
        context 'after cancel' do
          before { subject.cancel }
          it { expect(subject.response_errors).to eq({:status=>["cannot transition via cancel"]}) }
        end
      end
    end
    describe 'all', vcr: { cassette_name: 'resources/bank_billet/all'} do
      subject { BoletoSimples::BankBillet.all }
      it { expect(subject.first).to be_a_kind_of(BoletoSimples::BankBillet) }
    end
  end
end