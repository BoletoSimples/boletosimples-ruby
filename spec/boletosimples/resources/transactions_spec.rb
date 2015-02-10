# encoding: UTF-8

require 'spec_helper'

# Before running this spec again, you need to set environment variable BOLETOSIMPLES_ACCESS_TOKEN
RSpec.describe BoletoSimples::Transaction do
  before {
    BoletoSimples.configure do |c|
      c.application_id = nil
      c.application_secret = nil
    end
  }
  describe 'all', vcr: { cassette_name: 'resources/transaction/all'} do
    subject { BoletoSimples::Transaction.all }
    it { expect(subject.size).to eq(2) }
    it { expect(subject.first.attributes).to eq({"amount"=>9.01, "created_at"=>"2015-02-10", "description"=>"Boleto Bancário 688", "kind"=>"credit", "processed_at"=>nil, "sent_at"=>nil, "status"=>"unprocessed", "credit_at"=>"2015-02-19", "id"=>59}) }
  end
end