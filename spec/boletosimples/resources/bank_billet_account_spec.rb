# encoding: UTF-8

require 'spec_helper'

# Before running this spec again, you need to set environment variable BOLETOSIMPLES_ACCESS_TOKEN
RSpec.describe BoletoSimples::BankBilletAccount do
  before {
    BoletoSimples.configure do |c|
      c.application_id = nil
      c.application_secret = nil
    end
  }
  describe 'methods' do
    before {
      VCR.use_cassette('resources/bank_billet_account/create/valid') do
        @bank_billet_account = BoletoSimples::BankBilletAccount.create({
            bank_contract_slug: 'sicoob-02',
            next_our_number: '1',
            agency_number: '4327',
            agency_digit: '3',
            account_number: '3666',
            account_digit: '8',
            extra1_length: '1234567'
          })
      end
    }
    describe 'create' do
      context 'valid parameters' do
        subject { @bank_billet_account }
        it { expect(subject).to be_a_kind_of(BoletoSimples::BankBilletAccount) }
        it { expect(subject.response_errors).to eq({}) }
        it { expect(subject.attributes.keys).to match_array(["account_digit", "account_number", "agency_digit", "agency_number", "bank_contract_slug", "extra1", "extra1_digit", "extra1_length", "extra2", "extra2_digit", "id", "next_our_number"]) }
      end
      context 'invalid parameters' do
        context 'empty bank_billet' do
          subject {
            VCR.use_cassette('resources/bank_billet_account/create/invalid_root') do
              BoletoSimples::BankBilletAccount.create({})
            end
          }
          it { expect(subject.response_errors).to eq({ bank_billet_account: ["não pode ficar em branco"] }) }
        end
        context 'invalid params' do
          subject {
            VCR.use_cassette('resources/bank_billet_account/create/invalid_params') do
              BoletoSimples::BankBilletAccount.create({ bank_contract_slug: '' })
            end
          }
          it { expect(subject.response_errors).to eq({ :agency_number => ["não pode ficar em branco"], :account_number => ["não pode ficar em branco"], :bank_contract_slug => ["não pode ficar em branco"] }) }
        end
      end
    end
    describe 'find', vcr: { cassette_name: 'resources/bank_billet_account/find' } do
      subject { BoletoSimples::BankBilletAccount.find(@bank_billet_account.id) }
      it { expect(subject).to be_a_kind_of(BoletoSimples::BankBilletAccount) }
    end
    describe 'all', vcr: { cassette_name: 'resources/bank_billet_account/all' } do
      subject { BoletoSimples::BankBilletAccount.all }
      it { expect(subject.first).to be_a_kind_of(BoletoSimples::BankBilletAccount) }
    end
  end
end