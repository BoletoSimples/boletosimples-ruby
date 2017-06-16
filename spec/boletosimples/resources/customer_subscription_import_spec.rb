# encoding: UTF-8

require 'spec_helper'

# Before running this spec again, you need to set environment variable BOLETOSIMPLES_ACCESS_TOKEN
RSpec.describe BoletoSimples::CustomerSubscriptionImport do
  before {
    BoletoSimples.configure do |c|
      c.application_id = nil
      c.application_secret = nil
    end
  }
  describe 'methods' do
    before {
      VCR.use_cassette('resources/customer_subscription_import/create/valid') do
        @customer_subscription_import = BoletoSimples::CustomerSubscriptionImport.create({
          source: Faraday::UploadIO.new(File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'customer_subscription_imports.csv'), 'text/csv', 'customer_subscriptions.csv')
        })
      end
    }
    describe 'create' do
      context 'valid parameters' do
        subject { @customer_subscription_import }
        xit { expect(subject).to be_a_kind_of(BoletoSimples::CustomerSubscriptionImport) }
        xit { expect(subject.response_errors).to eq({}) }
        xit { expect(subject.attributes.keys).to match_array(["created_rows", "enqueued_at", "failed_to_create_rows", "failed_to_update_rows", "finished_at", "id", "import_errors", "processed_at", "processed_rows", "records_count", "source", "source_content_type", "source_file_name", "source_file_size", "source_updated_at", "started_at", "status", "total_rows", "updated_rows"]) }
      end
      context 'invalid parameters' do
        context 'empty bank_billet' do
          subject {
            VCR.use_cassette('resources/customer_subscription_import/create/invalid_root') do
              BoletoSimples::CustomerSubscriptionImport.create({})
            end
          }
          xit { expect(subject.response_errors).to eq({:customer_subscription_import=>["não pode ficar em branco"]}) }
        end
        context 'invalid params' do
          subject {
            VCR.use_cassette('resources/customer_subscription_import/create/invalid_params') do
              BoletoSimples::CustomerSubscriptionImport.create({source: ''})
            end
          }
          xit { expect(subject.response_errors).to eq(source: ["não pode ficar em branco"]) }
        end
      end
    end
    describe 'find', vcr: { cassette_name: 'resources/customer_subscription_import/find'} do
      subject { BoletoSimples::CustomerSubscriptionImport.find(@customer_subscription_import.id) }
      xit { expect(subject).to be_a_kind_of(BoletoSimples::CustomerSubscriptionImport) }
    end
    describe 'all', vcr: { cassette_name: 'resources/customer_subscription_import/all'} do
      subject { BoletoSimples::CustomerSubscriptionImport.all }
      xit { expect(subject.first).to be_a_kind_of(BoletoSimples::CustomerSubscriptionImport) }
    end
  end
end