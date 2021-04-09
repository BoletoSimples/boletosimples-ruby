# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BoletoSimples::LastRequest do
  describe 'bank_billets', vcr: { cassette_name: 'last_request/bank_billets' } do
    subject { BoletoSimples.last_request }

    before { BoletoSimples::BankBillet.all(page: 2).size }

    it do
      expect(subject).to be_kind_of(described_class)
      expect(subject.body).to be_kind_of(Array)
      expect(subject.body.first).to be_kind_of(Hash)
      expect(subject.response_headers).to be_kind_of(Hash)
      expect(subject.total).to be_kind_of(Integer)
      expect(subject.ratelimit_limit).to be_kind_of(Integer)
      expect(subject.ratelimit_remaining).to be_kind_of(Integer)
      expect(subject.links.keys).to match_array(%i[first next prev])
    end
  end
end
