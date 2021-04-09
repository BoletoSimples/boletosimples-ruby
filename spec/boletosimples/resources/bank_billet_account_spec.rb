# frozen_string_literal: true

require 'spec_helper'

# Before running this spec again, you need to set environment variable BOLETOSIMPLES_API_TOKEN
RSpec.describe BoletoSimples::BankBilletAccount do
  describe 'methods' do
    before do
      VCR.use_cassette('resources/bank_billet_account/create/valid') do
        @bank_billet_account = described_class.create(
          bank_contract_slug: 'sicoob-02',
          next_our_number: '1',
          agency_number: '4327',
          agency_digit: '3',
          account_number: '3666',
          account_digit: '8',
          extra1: '1234567',
          beneficiary_name: 'XPTO S.A.',
          beneficiary_cnpj_cpf: '22.622.867/0001-11',
          beneficiary_address_street: 'Rua S',
          beneficiary_address_city: 'São Paulo',
          beneficiary_address_state: 'SP',
          beneficiary_address_neighborhood: 'Moema',
          beneficiary_address_zipcode: '04524030'
        )
      end
    end

    describe 'create' do
      context 'valid parameters' do
        subject { @bank_billet_account }

        it do
          expect(subject).to be_a_kind_of(described_class)
          expect(subject.response_errors).to eq({})
        end
      end

      context 'invalid parameters' do
        context 'empty bank_billet' do
          subject do
            VCR.use_cassette('resources/bank_billet_account/create/invalid_root') do
              described_class.create({})
            end
          end

          it {
            expect(subject.response_errors).to eq([{ code: 422, status: 422,
                                                     title: 'bank_billet_account não pode ficar em branco' }])
          }
        end

        context 'invalid params' do
          subject do
            VCR.use_cassette('resources/bank_billet_account/create/invalid_params') do
              described_class.create({ bank_contract_slug: '' })
            end
          end

          it {
            expect(subject.response_errors).to eq({ bank_contract_slug: ['não pode ficar em branco'],
                                                    beneficiary_name: ['não pode ficar em branco'],
                                                    beneficiary_cnpj_cpf: ['não pode ficar em branco'],
                                                    beneficiary_address_street: ['não pode ficar em branco'],
                                                    beneficiary_address_city: ['não pode ficar em branco'],
                                                    beneficiary_address_neighborhood: ['não pode ficar em branco'],
                                                    beneficiary_address_state: ['não pode ficar em branco'],
                                                    beneficiary_address_zipcode: ['não pode ficar em branco'] })
          }
        end
      end
    end

    describe 'find', vcr: { cassette_name: 'resources/bank_billet_account/find' } do
      subject { described_class.find(@bank_billet_account.id) }

      it { expect(subject).to be_a_kind_of(described_class) }
    end

    describe 'all', vcr: { cassette_name: 'resources/bank_billet_account/all' } do
      subject { described_class.all }

      it { expect(subject.first).to be_a_kind_of(described_class) }
    end
  end
end
