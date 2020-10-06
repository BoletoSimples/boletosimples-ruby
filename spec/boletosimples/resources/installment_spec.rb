# frozen_string_literal: true

require 'spec_helper'

# Before running this spec again, you need to set environment variable BOLETOSIMPLES_ACCESS_TOKEN
RSpec.describe BoletoSimples::Installment do
  before do
    BoletoSimples.configure do |c|
      c.application_id = nil
      c.application_secret = nil
    end
  end
  describe 'methods' do
    before do
      VCR.use_cassette('resources/installment/create/valid') do
        @installment = BoletoSimples::Installment.create({
                                                           customer_id: '11',
                                                           bank_billet_account_id: '12',
                                                           amount: '1.120,4',
                                                           cycle: 'monthly',
                                                           start_at: '2016-09-15',
                                                           total: '3',
                                                           description: 'Hospedagem'
                                                         })
      end
    end
    describe 'create' do
      context 'valid parameters' do
        subject { @installment }
        it { expect(subject).to be_a_kind_of(BoletoSimples::Installment) }
        it { expect(subject.response_errors).to eq({}) }
        it { expect(subject.attributes.keys).to match_array(%w[amount bank_billet_account_id created_at created_via_api customer_id cycle description end_at id instructions start_at status total updated_at]) }
      end
      context 'invalid parameters' do
        context 'empty bank_billet' do
          subject do
            VCR.use_cassette('resources/installment/create/invalid_root') do
              BoletoSimples::Installment.create({})
            end
          end
          it { expect(subject.response_errors).to eq({ installment: ['não pode ficar em branco'] }) }
        end
        context 'invalid params' do
          subject do
            VCR.use_cassette('resources/installment/create/invalid_params') do
              BoletoSimples::Installment.create({ person_name: '' })
            end
          end
          it { expect(subject.response_errors).to eq({ customer: ['não pode ficar em branco'], bank_billet_account: ['não pode ficar em branco'], cycle: ['não pode ficar em branco', 'não está incluído na lista'], total: ['não pode ficar em branco'], start_at: ['não pode ficar em branco'], description: ['não pode ficar em branco'], amount: ['deve ser maior que 0'] }) }
        end
      end
    end
    describe 'find', vcr: { cassette_name: 'resources/installment/find' } do
      subject { BoletoSimples::Installment.find(@installment.id) }
      it { expect(subject).to be_a_kind_of(BoletoSimples::Installment) }
    end
    describe 'all', vcr: { cassette_name: 'resources/installment/all' } do
      subject { BoletoSimples::Installment.all }
      it { expect(subject.first).to be_a_kind_of(BoletoSimples::Installment) }
    end
  end
end
