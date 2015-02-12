# encoding: UTF-8
require 'spec_helper'

RSpec.describe BoletoSimples::LastRequest do
  before {
    BoletoSimples.configure do |c|
      c.application_id = nil
      c.application_secret = nil
    end
  }
  describe 'bank_billets', vcr: { cassette_name: 'last_request/bank_billets'} do
    before { BoletoSimples::BankBillet.all.size }
    subject { BoletoSimples.last_request }
    it { expect(subject).to be_kind_of(BoletoSimples::LastRequest) }
    it { expect(subject.body).to be_kind_of(Array) }
    it { expect(subject.body.first).to be_kind_of(Hash) }
    it { expect(subject.response_headers).to be_kind_of(Hash) }
    it { expect(subject.total).to be_kind_of(Integer) }
    it { expect(subject.ratelimit_limit).to be_kind_of(Integer) }
    it { expect(subject.ratelimit_remaining).to be_kind_of(Integer) }
    it { expect(subject.links.keys).to match_array([:next, :last]) }
  end
  describe 'user_info', vcr: { cassette_name: 'last_request/userinfo'} do
    before { BoletoSimples::Extra.userinfo }
    subject { BoletoSimples.last_request }
    it { expect(subject).to be_kind_of(BoletoSimples::LastRequest) }
    it { expect(subject.body).to be_kind_of(Hash) }
    it { expect(subject.response_headers).to be_kind_of(Hash) }
    it { expect(subject.total).to eq(0) }
    it { expect(subject.ratelimit_limit).to be_kind_of(Integer) }
    it { expect(subject.ratelimit_remaining).to be_kind_of(Integer) }
    it { expect(subject.links).to eq({}) }
  end
end
