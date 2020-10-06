# frozen_string_literal: true

require 'spec_helper'

# Before running this spec again, you need to set environment variable BOLETOSIMPLES_ACCESS_TOKEN
RSpec.describe BoletoSimples::BankBilletPayment do
  before do
    BoletoSimples.configure do |c|
      c.application_id = nil
      c.application_secret = nil
    end
  end
  describe 'all', vcr: { cassette_name: 'resources/bank_billet_payment/all' } do
    subject { BoletoSimples::BankBilletPayment.all }
    it { expect(subject.first).to be_a_kind_of(BoletoSimples::BankBilletPayment) }
  end
end
