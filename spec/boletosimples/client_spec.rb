# encoding: UTF-8

require 'spec_helper'

RSpec.describe BoletoSimples::Client do

  describe '#user_info' do

    context 'without authentication', :vcr do
      let(:client) { BoletoSimples::Client.new(nil, user_agent: 'Meu e-Commerce (meuecommerce@example.com)') }

      it { expect(client.userinfo).to eq('error' => 'Você precisa se logar ou registrar antes de prosseguir.') }
    end
  end
end
