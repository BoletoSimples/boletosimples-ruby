# -*- encoding: utf-8 -*-
require 'spec_helper'

describe BoletoSimples::Client do
  describe :userinfo do
    context :without_authentication do
      let(:client) { BoletoSimples::Client.new(nil, nil, {user_agent: 'Meu e-Commerce (meuecommerce@example.com)'}) }
      it { expect(client.userinfo).to eq({"error"=>"Você precisa se logar ou registrar antes de prosseguir."}) }
    end
  end
end
