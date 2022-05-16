# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BoletoSimples::Middleware::CustomHeaders do
  describe 'bank_billets', vcr: { cassette_name: 'custom_headers' } do
    subject { BoletoSimples.last_request }

    before do
      BoletoSimples.configure do |c|
        c.custom_headers = {
          'X-CUSTOM' => 'CONTENT'
        }
      end
      BoletoSimples::BankBillet.all(page: 2).size
    end

    after do
      BoletoSimples.configure
    end

    it do
      expect(subject.request_headers).to include({ 'X-CUSTOM' => 'CONTENT' })
    end
  end
end
