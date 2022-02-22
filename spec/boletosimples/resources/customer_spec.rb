# frozen_string_literal: true

require 'spec_helper'

# Before running this spec again, you need to set environment variable BOLETOSIMPLES_API_TOKEN
RSpec.describe BoletoSimples::Customer do
  describe 'methods' do
    before do
      VCR.use_cassette('resources/customer/create/valid') do
        @customer = described_class.create(
          person_name: 'Maria José',
          cnpj_cpf: '84.232.027/0001-08',
          email: 'cliente@example.com',
          address: 'Rua quinhentos',
          city_name: 'Rio de Janeiro',
          state: 'RJ',
          neighborhood: 'bairro',
          zipcode: '12312-123',
          address_number: '111',
          address_complement: 'Sala 4',
          phone_number: '2112123434'
        )
      end
    end

    describe 'create' do
      context 'valid parameters' do
        subject { @customer }

        it do
          expect(subject).to be_a_kind_of(described_class)
          expect(subject.response_errors).to eq({})
        end
      end

      context 'invalid parameters' do
        context 'empty bank_billet' do
          subject do
            VCR.use_cassette('resources/customer/create/invalid_root') do
              described_class.create({})
            end
          end

          it {
            expect(subject.response_errors).to eq({ address: ['não pode ficar em branco'],
                                                    city_name: ['não pode ficar em branco'],
                                                    cnpj_cpf: ['não é um CNPJ ou CPF válido'],
                                                    neighborhood: ['não pode ficar em branco'],
                                                    person_name: ['não pode ficar em branco'],
                                                    state: ['não está incluído na lista'],
                                                    zipcode: ['não pode ficar em branco'] })
          }
        end

        context 'invalid params' do
          subject do
            VCR.use_cassette('resources/customer/create/invalid_params') do
              described_class.create({ person_name: '' })
            end
          end

          it {
            expect(subject.response_errors).to eq({ person_name: ['não pode ficar em branco'],
                                                    cnpj_cpf: ['não é um CNPJ ou CPF válido'], zipcode: ['não pode ficar em branco'],
                                                    address: ['não pode ficar em branco'], neighborhood: ['não pode ficar em branco'],
                                                    city_name: ['não pode ficar em branco'], state: ['não está incluído na lista'] })
          }
        end
      end
    end

    describe 'find', vcr: { cassette_name: 'resources/customer/find' } do
      subject { described_class.find(@customer.id) }

      it { expect(subject).to be_a_kind_of(described_class) }
    end

    describe 'all', vcr: { cassette_name: 'resources/customer/all' } do
      subject { described_class.all }

      it { expect(subject.first).to be_a_kind_of(described_class) }
    end
  end
end
