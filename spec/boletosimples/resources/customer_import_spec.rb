# frozen_string_literal: true

require 'spec_helper'

# Before running this spec again, you need to set environment variable BOLETOSIMPLES_API_TOKEN
RSpec.describe BoletoSimples::CustomerImport do
  describe 'methods' do
    before do
      VCR.use_cassette('resources/customer_import/create/valid') do
        @customer_import = described_class.create({
                                                    source: Faraday::UploadIO.new(
                                                      File.join(File.dirname(__FILE__), '..', '..',
                                                                'fixtures', 'customer_imports.csv'), 'text/csv', 'customers.csv'
                                                    )
                                                  })
      end
    end

    describe 'create' do
      context 'valid parameters' do
        subject { @customer_import }

        it do
          expect(subject).to be_a_kind_of(described_class)
          expect(subject.response_errors).to eq({})
        end
      end

      context 'invalid parameters' do
        context 'empty bank_billet' do
          subject do
            VCR.use_cassette('resources/customer_import/create/invalid_root') do
              described_class.create({})
            end
          end

          it {
            expect(subject.response_errors).to eq([{ code: 422, status: 422,
                                                     title: 'customer_import não pode ficar em branco' }])
          }
        end

        context 'invalid params' do
          subject do
            VCR.use_cassette('resources/customer_import/create/invalid_params') do
              described_class.create({ source: '' })
            end
          end

          it { expect(subject.response_errors).to eq(source: ['não pode ficar em branco']) }
        end
      end
    end

    describe 'find', vcr: { cassette_name: 'resources/customer_import/find' } do
      subject { described_class.find(@customer_import.id) }

      it { expect(subject).to be_a_kind_of(described_class) }
    end

    describe 'all', vcr: { cassette_name: 'resources/customer_import/all' } do
      subject { described_class.all }

      it { expect(subject.first).to be_a_kind_of(described_class) }
    end
  end
end
