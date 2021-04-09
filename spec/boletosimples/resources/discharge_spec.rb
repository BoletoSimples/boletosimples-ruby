# frozen_string_literal: true

require 'spec_helper'

# Before running this spec again, you need to set environment variable BOLETOSIMPLES_API_TOKEN
RSpec.describe BoletoSimples::Discharge do
  describe 'methods' do
    before do
      VCR.use_cassette('resources/discharge/create/valid') do
        @discharge = described_class.create({
                                              file: Faraday::UploadIO.new(
                                                File.join(File.dirname(__FILE__), '..', '..',
                                                          'fixtures', 'discharge.RET'), 'text/plain', 'discharge.RET'
                                              )
                                            })
      end
    end

    describe 'create' do
      context 'valid parameters' do
        subject { @discharge }

        it do
          expect(subject).to be_a_kind_of(described_class)
          expect(subject.response_errors).to eq({})
        end
      end

      context 'invalid parameters' do
        context 'empty bank_billet' do
          subject do
            VCR.use_cassette('resources/discharge/create/invalid_root') do
              described_class.create({})
            end
          end

          it {
            expect(subject.response_errors).to eq([{ code: 422, status: 422,
                                                     title: 'discharge não pode ficar em branco' }])
          }
        end

        context 'invalid params' do
          subject do
            VCR.use_cassette('resources/discharge/create/invalid_params') do
              described_class.create({ content: '' })
            end
          end

          it {
            expect(subject.response_errors).to eq({ content: ['não pode ficar em branco'],
                                                    filename: ['não pode ficar em branco'] })
          }
        end
      end
    end

    describe 'find', vcr: { cassette_name: 'resources/discharge/find' } do
      subject { described_class.find(@discharge.id) }

      it { expect(subject).to be_a_kind_of(described_class) }
    end

    describe 'all', vcr: { cassette_name: 'resources/discharge/all' } do
      subject { described_class.all }

      it { expect(subject.first).to be_a_kind_of(described_class) }
    end
  end
end
