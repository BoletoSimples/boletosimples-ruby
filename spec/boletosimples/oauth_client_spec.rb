# # encoding: UTF-8
#
# require 'spec_helper'
#
# RSpec.describe BoletoSimples::OAuthClient do
#
#   describe '#userinfo' do
#
#     context 'without authentication', :vcr do
#       let(:credentials) { { token: 'invalid-token' } }
#       let(:client_options) { { user_agent: 'Meu e-Commerce (meuecommerce@example.com)' } }
#       let(:client) { BoletoSimples::OAuthClient.new(nil, nil, credentials, client_options) }
#
#       it { expect(client.userinfo).to eq('error' => 'Você precisa se logar ou registrar antes de prosseguir.') }
#     end
#   end
# end
