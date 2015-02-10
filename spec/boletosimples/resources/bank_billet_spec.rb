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
  describe 'all', vcr: { cassette_name: 'resources/bank_billet/all'} do
    subject { BoletoSimples::BankBillet.all }
    it { expect(subject.size).to eq(1) }
    it { expect(subject.first.attributes).to eq({"expire_at"=>"2014-04-01", "paid_at"=>nil, "description"=>"Testes da GEM", "status"=>"opened", "shorten_url"=>"http://staging.bole.to/2l8v7y1i", "customer_person_type"=>"individual", "customer_person_name"=>"Renata Celi", "customer_cnpj_cpf"=>"103.326.587-08", "customer_address"=>"Av. Rui Barbosa", "customer_state"=>"RJ", "customer_neighborhood"=>"São Francisco", "customer_zipcode"=>"24360-440", "customer_address_number"=>"457", "customer_address_complement"=>"301", "customer_phone_number"=>"21994912476", "customer_email"=>"contato@rafael.adm.br", "notification_url"=>nil, "send_email_on_creation"=>nil, "created_via_api"=>false, "customer_city_name"=>"Niterói", "paid_amount"=>0.0, "amount"=>10.0, "parcel"=>1, "parent_id"=>nil, "all_parcels_ids"=>[7], "id"=>7}) }
  end
  describe 'create', vcr: { cassette_name: 'resources/bank_billet/create'} do
    subject {
      BoletoSimples::BankBillet.create({
        amount: '9,01',
        description: 'Despesas do contrato 0012',
        expire_at: '2014-01-01',
        customer_address: 'Rua quinhentos',
        customer_address_complement: 'Sala 4',
        customer_address_number: '111',
        customer_city_name: 'Rio de Janeiro',
        customer_cnpj_cpf: '012.345.678-90',
        customer_email: 'cliente@bom.com',
        customer_neighborhood: 'Sao Francisco',
        customer_person_name: 'Joao da Silva',
        customer_person_type: 'individual',
        customer_phone_number: '2112123434',
        customer_state: 'RJ',
        customer_zipcode: '12312-123',
        notification_url: 'http://example.com.br/notify'
      })
    }
    it { expect(subject.errors.messages).to eq({}) }
    it { expect(subject.attributes).to eq({"amount"=>9.01, "description"=>"Despesas do contrato 0012", "expire_at"=>"2014-01-01", "customer_address"=>"Rua quinhentos", "customer_address_complement"=>"Sala 4", "customer_address_number"=>"111", "customer_city_name"=>"Rio de Janeiro", "customer_cnpj_cpf"=>"012.345.678-90", "customer_email"=>"cliente@bom.com", "customer_neighborhood"=>"Sao Francisco", "customer_person_name"=>"Joao da Silva", "customer_person_type"=>"individual", "customer_phone_number"=>"2112123434", "customer_state"=>"RJ", "customer_zipcode"=>"12312-123", "notification_url"=>"http://example.com.br/notify", "id"=>688, "paid_at"=>nil, "status"=>"generating", "shorten_url"=>nil, "send_email_on_creation"=>nil, "created_via_api"=>true, "paid_amount"=>0.0, "parcel"=>1, "parent_id"=>nil, "all_parcels_ids"=>[688]}) }
  end
  describe 'find', vcr: { cassette_name: 'resources/bank_billet/find'} do
    subject { BoletoSimples::BankBillet.find(688) }
    it { expect(subject.attributes).to eq({"amount"=>9.01, "description"=>"Despesas do contrato 0012", "expire_at"=>"2014-01-01", "customer_address"=>"Rua quinhentos", "customer_address_complement"=>"Sala 4", "customer_address_number"=>"111", "customer_city_name"=>"Rio de Janeiro", "customer_cnpj_cpf"=>"012.345.678-90", "customer_email"=>"cliente@bom.com", "customer_neighborhood"=>"Sao Francisco", "customer_person_name"=>"Joao da Silva", "customer_person_type"=>"individual", "customer_phone_number"=>"2112123434", "customer_state"=>"RJ", "customer_zipcode"=>"12312-123", "notification_url"=>"http://example.com.br/notify", "id"=>688, "paid_at"=>nil, "status"=>"generating", "shorten_url"=>nil, "send_email_on_creation"=>nil, "created_via_api"=>true, "paid_amount"=>0.0, "parcel"=>1, "parent_id"=>nil, "all_parcels_ids"=>[688]}) }
  end
  describe 'cancel', vcr: { cassette_name: 'resources/bank_billet/cancel'} do
    subject { BoletoSimples::BankBillet.find(688).cancel }
    it { expect(subject.attributes).to eq({"expire_at"=>"2014-01-01", "paid_at"=>nil, "description"=>"Despesas do contrato 0012", "status"=>"canceled", "shorten_url"=>"http://staging.bole.to/ni1zav8m", "customer_person_type"=>"individual", "customer_person_name"=>"Joao da Silva", "customer_cnpj_cpf"=>"012.345.678-90", "customer_address"=>"Rua quinhentos", "customer_state"=>"RJ", "customer_neighborhood"=>"Sao Francisco", "customer_zipcode"=>"12312-123", "customer_address_number"=>"111", "customer_address_complement"=>"Sala 4", "customer_phone_number"=>"2112123434", "customer_email"=>"cliente@bom.com", "notification_url"=>"http://example.com.br/notify", "send_email_on_creation"=>nil, "created_via_api"=>true, "customer_city_name"=>"Rio de Janeiro", "paid_amount"=>0.0, "amount"=>9.01, "parcel"=>1, "parent_id"=>nil, "all_parcels_ids"=>[688], "id"=>688}) }
  end
end