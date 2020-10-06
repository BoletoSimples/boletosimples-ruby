# frozen_string_literal: true

require 'spec_helper'

# Before running this spec again, you need to set environment variable BOLETOSIMPLES_ACCESS_TOKEN
RSpec.describe BoletoSimples::CustomerSubscription do
  before do
    BoletoSimples.configure do |c|
      c.application_id = nil
      c.application_secret = nil
    end
  end
  describe 'methods' do
    before do
      VCR.use_cassette('resources/customer_subscription/create/valid') do
        @customer_subscription = BoletoSimples::CustomerSubscription.create({
                                                                              customer_id: '11',
                                                                              bank_billet_account_id: '12',
                                                                              amount: '1.120,4',
                                                                              cycle: 'monthly',
                                                                              description: 'Hospedagem'
                                                                            })
      end
    end
    describe 'create' do
      context 'valid parameters' do
        subject { @customer_subscription }
        it { expect(subject).to be_a_kind_of(BoletoSimples::CustomerSubscription) }
        it { expect(subject.response_errors).to eq({}) }
        it { expect(subject.attributes.keys).to match_array(%w[amount bank_billet_account_id created_at created_via_api customer_id cycle days_in_advance description end_at id instructions next_billing updated_at]) }
      end
      context 'invalid parameters' do
        context 'empty bank_billet' do
          subject do
            VCR.use_cassette('resources/customer_subscription/create/invalid_root') do
              BoletoSimples::CustomerSubscription.create({})
            end
          end
          it { expect(subject.response_errors).to eq({ customer_subscription: ['não pode ficar em branco'] }) }
        end
        context 'invalid params' do
          subject do
            VCR.use_cassette('resources/customer_subscription/create/invalid_params') do
              BoletoSimples::CustomerSubscription.create({ customer_id: '' })
            end
          end
          it { expect(subject.response_errors).to eq({ customer: ['não pode ficar em branco'], bank_billet_account: ['não pode ficar em branco'], amount: ['não pode ficar em branco'], description: ['não pode ficar em branco'] }) }
        end
      end
    end
    describe 'find', vcr: { cassette_name: 'resources/customer_subscription/find' } do
      subject { BoletoSimples::CustomerSubscription.find(@customer_subscription.id) }
      it { expect(subject).to be_a_kind_of(BoletoSimples::CustomerSubscription) }
    end
    describe 'all', vcr: { cassette_name: 'resources/customer_subscription/all' } do
      subject { BoletoSimples::CustomerSubscription.all }
      it { expect(subject.first).to be_a_kind_of(BoletoSimples::CustomerSubscription) }
    end
    describe 'cancel' do
      context 'success', vcr: { cassette_name: 'resources/customer_subscription/next_charge' } do
        subject { BoletoSimples::CustomerSubscription.find(@customer_subscription.id) }
        it { expect(subject.next_charge).to be_truthy }
      end
    end
  end
end
