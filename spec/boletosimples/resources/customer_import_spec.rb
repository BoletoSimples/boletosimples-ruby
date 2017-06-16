# encoding: UTF-8

require 'spec_helper'

# Before running this spec again, you need to set environment variable BOLETOSIMPLES_ACCESS_TOKEN
RSpec.describe BoletoSimples::CustomerImport do
  before {
    BoletoSimples.configure do |c|
      c.application_id = nil
      c.application_secret = nil
    end
  }
  describe 'methods' do
    before {
      VCR.use_cassette('resources/customer_import/create/valid') do
        @customer_import = BoletoSimples::CustomerImport.create({
          source: Faraday::UploadIO.new(File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'customer_imports.csv'), 'text/csv', 'customers.csv')
        })
      end
    }
    describe 'create' do
      context 'valid parameters' do
        subject { @customer_import }
        it { expect(subject).to be_a_kind_of(BoletoSimples::CustomerImport) }
        it { expect(subject.response_errors).to eq({}) }
        it { expect(subject.attributes.keys).to match_array(["created_rows", "enqueued_at", "failed_to_create_rows", "failed_to_update_rows", "finished_at", "id", "import_errors", "processed_at", "processed_rows", "records_count", "source", "source_content_type", "source_file_name", "source_file_size", "source_updated_at", "started_at", "status", "total_rows", "updated_rows"]) }
      end
      context 'invalid parameters' do
        context 'empty bank_billet' do
          subject {
            VCR.use_cassette('resources/customer_import/create/invalid_root') do
              BoletoSimples::CustomerImport.create({})
            end
          }
          it { expect(subject.response_errors).to eq({:customer_import=>["não pode ficar em branco"]}) }
        end
        context 'invalid params' do
          subject {
            VCR.use_cassette('resources/customer_import/create/invalid_params') do
              BoletoSimples::CustomerImport.create({source: ''})
            end
          }
          it { expect(subject.response_errors).to eq(source: ["não pode ficar em branco"]) }
        end
      end
    end
    describe 'find', vcr: { cassette_name: 'resources/customer_import/find'} do
      subject { BoletoSimples::CustomerImport.find(@customer_import.id) }
      it { expect(subject).to be_a_kind_of(BoletoSimples::CustomerImport) }
    end
    describe 'all', vcr: { cassette_name: 'resources/customer_import/all'} do
      subject { BoletoSimples::CustomerImport.all }
      it { expect(subject.first).to be_a_kind_of(BoletoSimples::CustomerImport) }
    end
  end
end