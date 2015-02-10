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
  describe 'all', vcr: { cassette_name: 'resources/customer/all'} do
    subject { BoletoSimples::Customer.all }
    it { expect(subject.size).to eq(1) }
    it { expect(subject.first.attributes).to eq({"city_name"=>"Rio de Janeiro", "person_name"=>"Joao da Silva", "address"=>"Rua quinhentos", "address_complement"=>"Sala 4", "address_number"=>"111", "mobile_number"=>nil, "cnpj_cpf"=>"012.345.678-90", "email"=>"cliente@bom.com", "neighborhood"=>"Sao Francisco", "person_type"=>"individual", "phone_number"=>"2112123434", "zipcode"=>"12312-123", "mobile_local_code"=>nil, "state"=>"RJ", "created_via_api"=>true, "id"=>57}) }
  end
  describe 'create', vcr: { cassette_name: 'resources/customer/create'} do
    subject {
      BoletoSimples::Customer.create({
        person_name: "Maria José",
        cnpj_cpf: "223.886.692-27",
        email: "cliente@bom.com",
        address: "Rua quinhentos",
        city_name: "Rio de Janeiro",
        state: "RJ",
        neighborhood: "bairro",
        zipcode: "12312-123",
        address_number: "111",
        address_complement: "Sala 4",
        phone_number: "2112123434"
      })
    }
    it { expect(subject.errors.messages).to eq({}) }
    it { expect(subject.attributes).to eq({"person_name"=>"Maria José", "cnpj_cpf"=>"223.886.692-27", "email"=>"cliente@bom.com", "address"=>"Rua quinhentos", "city_name"=>"Rio de Janeiro", "state"=>"RJ", "neighborhood"=>"bairro", "zipcode"=>"12312-123", "address_number"=>"111", "address_complement"=>"Sala 4", "phone_number"=>"2112123434", "mobile_number"=>nil, "person_type"=>"individual", "mobile_local_code"=>nil, "created_via_api"=>true, "id"=>58}) }
  end
  describe 'find', vcr: { cassette_name: 'resources/customer/find'} do
    subject { BoletoSimples::Customer.find(57) }
    it { expect(subject.attributes).to eq({"city_name"=>"Rio de Janeiro", "person_name"=>"Joao da Silva", "address"=>"Rua quinhentos", "address_complement"=>"Sala 4", "address_number"=>"111", "mobile_number"=>nil, "cnpj_cpf"=>"012.345.678-90", "email"=>"cliente@bom.com", "neighborhood"=>"Sao Francisco", "person_type"=>"individual", "phone_number"=>"2112123434", "zipcode"=>"12312-123", "mobile_local_code"=>nil, "state"=>"RJ", "created_via_api"=>true, "id"=>57}) }
  end
end