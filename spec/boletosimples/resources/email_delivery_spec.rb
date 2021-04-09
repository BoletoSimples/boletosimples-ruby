# frozen_string_literal: true

require 'spec_helper'

# Before running this spec again, you need to set environment variable BOLETOSIMPLES_API_TOKEN
RSpec.describe BoletoSimples::EmailDelivery do
  describe 'all', vcr: { cassette_name: 'resources/email_delivery/all' } do
    subject { described_class.all }

    it { expect(subject.first).to be_nil }
  end
end
