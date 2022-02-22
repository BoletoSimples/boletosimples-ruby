# # frozen_string_literal: true

# require 'spec_helper'

# RSpec.describe BoletoSimples::Configuration do
#   describe 'defaults' do
#     subject { described_class.new }

#     before do
#       stub_env('BOLETOSIMPLES_ENV', nil)
#       stub_env('BOLETOSIMPLES_USER_AGENT', nil)
#       subject.setup_her
#     end

#     it do
#       expect(subject.environment).to eq(:sandbox)
#       expect(subject.base_uri).to eq('https://api-sandbox.kobana.com.br/v1')
#       expect(subject.cache).to be_nil
#       expect(subject.user_agent).to be_nil
#     end
#   end

#   describe 'environment variables' do
#     subject { BoletoSimples.configuration }

#     before do
#       stub_env('BOLETOSIMPLES_ENV', 'production')
#       stub_env('BOLETOSIMPLES_USER_AGENT', 'email@minhaempresa.com.br')
#       BoletoSimples.configure
#     end

#     it do
#       expect(subject.environment).to eq(:production)
#       expect(subject.base_uri).to eq('https://api.kobana.com.br/v1')
#       expect(subject.user_agent).to eq('email@minhaempresa.com.br')
#     end

#     describe 'cache' do
#       it do
#         expect(subject.cache).to be_nil
#         expect(Her::API.default_api.connection.builder.handlers).not_to include(Faraday::HttpCache)
#       end
#     end
#   end

#   describe 'configuration' do
#     subject { BoletoSimples.configuration }

#     let(:cache_object) { double('Dalli') }

#     before do
#       BoletoSimples.configure do |c|
#         c.environment = :production
#         c.cache = cache_object
#         c.user_agent = 'Meu agent'
#       end
#     end

#     it do
#       expect(subject.environment).to eq(:production)
#       expect(subject.user_agent).to eq('Meu agent')
#       expect(subject.base_uri).to eq('https://api.kobana.com.br/v1')
#     end

#     describe 'cache' do
#       it do
#         expect(subject.cache).to eq(cache_object)
#         expect(Her::API.default_api.connection.builder.handlers).to include(Faraday::HttpCache)
#       end
#     end
#   end
# end
