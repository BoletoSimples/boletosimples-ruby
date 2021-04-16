# frozen_string_literal: true

module BoletoSimples
  class Configuration
    attr_accessor :environment, :cache, :user_agent, :api_token

    BASE_URI = {
      sandbox: 'https://sandbox.boletosimples.com.br/api/v1',
      production: 'https://boletosimples.com.br/api/v1',
      development: 'http://localhost:5000/api/v1'
    }.freeze

    def initialize
      @environment = (ENV['BOLETOSIMPLES_ENV'] || :sandbox).to_sym
      @api_token = ENV['BOLETOSIMPLES_API_TOKEN']
      @user_agent = ENV['BOLETOSIMPLES_USER_AGENT']
      @cache = nil
    end

    def base_uri
      BASE_URI[@environment]
    end

    def api_token?
      !@api_token.nil?
    end

    def setup_her
      Her::API.setup url: base_uri do |c|
        # Request
        c.use BoletoSimples::Middleware::UserAgent
        c.use BoletoSimples::Middleware::Bearer if api_token?
        c.use Faraday::Request::Multipart
        c.use FaradayMiddleware::EncodeJson
        c.use Her::Middleware::AcceptJSON
        c.use Faraday::HttpCache, store: cache unless cache.nil?

        # Response
        c.use BoletoSimples::Middleware::LastRequest
        c.use BoletoSimples::Middleware::RaiseError
        c.use Her::Middleware::DefaultParseJSON

        # Adapter
        c.adapter Faraday::Adapter::NetHttp
      end

      # Because Her set the api on the moment module is included we need to call use_api again, after changing the configuration.
      [BankBillet, BankBilletAccount, Customer, CustomerImport, CustomerSubscription,
       CustomerSubscriptionImport, Installment, Transaction, Webhook, Discharge,
       Remittance, WebhookDelivery, Event, EmailDelivery, BankBilletDischarge,
       BankBilletPayment, BankBilletRemittance, SmsDelivery].each do |klass|
        klass.send(:use_api, Her::API.default_api)
      end
    end
  end
end
