# frozen_string_literal: true

require 'spec_helper'

# Before running this spec again, you need to set environment variable BOLETOSIMPLES_API_TOKEN
RSpec.describe BoletoSimples::BankBillet do
  describe 'methods' do
    before do
      VCR.use_cassette('resources/bank_billet/create/valid') do
        @bank_billet = described_class.create(
          amount: 9.01,
          description: 'Despesas do contrato 0012',
          expire_at: '2024-01-01',
          customer_address: 'Rua quinhentos',
          customer_address_complement: 'Sala 4',
          customer_address_number: '111',
          customer_city_name: 'Rio de Janeiro',
          customer_cnpj_cpf: '34.565.715/0001-03',
          customer_email: 'cliente@example.com',
          customer_neighborhood: 'Sao Francisco',
          customer_person_name: 'Joao da Silva',
          customer_person_type: 'individual',
          customer_phone_number: '2112123434',
          customer_state: 'RJ',
          customer_zipcode: '12312-123'
        )
      end
    end

    describe 'create' do
      context 'valid parameters' do
        subject { @bank_billet }

        it do
          expect(subject).to be_a_kind_of(described_class)
          expect(subject.response_errors).to eq({})
        end
      end

      context 'invalid parameters' do
        context 'empty bank_billet' do
          subject do
            VCR.use_cassette('resources/bank_billet/create/invalid_root') do
              described_class.create({})
            end
          end

          it {
            expect(subject.response_errors).to eq([{ code: 422, status: 422,
                                                     title: 'bank_billet não pode ficar em branco' }])
          }
        end

        context 'invalid params' do
          subject do
            VCR.use_cassette('resources/bank_billet/create/invalid_params') do
              described_class.create({ amount: 9.1 })
            end
          end

          it {
            expect(subject.response_errors).to eq({ customer_person_name: ['não pode ficar em branco'],
                                                    customer_cnpj_cpf: ['não é um CNPJ ou CPF válido'],
                                                    customer_zipcode: ['não pode ficar em branco'],
                                                    expire_at: ['não pode ficar em branco', 'não é uma data válida'],
                                                    customer_address: ['não pode ficar em branco'],
                                                    customer_neighborhood: ['não pode ficar em branco'],
                                                    customer_city_name: ['não pode ficar em branco'],
                                                    customer_state: ['não está incluído na lista'] })
          }
        end
      end
    end

    describe 'find', vcr: { cassette_name: 'resources/bank_billet/find' } do
      subject { described_class.find(@bank_billet.id) }

      it { expect(subject).to be_a_kind_of(described_class) }
    end

    describe 'cancel' do
      context 'success', vcr: { cassette_name: 'resources/bank_billet/cancel/success' } do
        it { expect(described_class.cancel(id: @bank_billet.id)).to be_truthy }
      end
    end

    describe 'duplicate' do
      context 'success', vcr: { cassette_name: 'resources/bank_billet/duplicate/success' } do
        it { expect(described_class.duplicate(id: @bank_billet.id)).to be_truthy }
      end
    end

    describe 'all', vcr: { cassette_name: 'resources/bank_billet/all' } do
      subject { described_class.all }

      it { expect(subject.first).to be_a_kind_of(described_class) }
    end
  end
end
