# frozen_string_literal: true

module BoletoSimples
  class Configuration
    attr_accessor :environment, :cache, :user_agent, :custom_headers, :api_token, :debug

    BASE_URI = {
      sandbox: 'https://api-sandbox.kobana.com.br/v1',
      production: 'https://api.kobana.com.br/v1',
      development: 'http://localhost:5000/api/v1'
    }.freeze

    def initialize
      @environment = ENV.fetch('BOLETOSIMPLES_ENV', :sandbox).to_sym
      @api_token = ENV.fetch('BOLETOSIMPLES_API_TOKEN', nil)
      @user_agent = ENV.fetch('BOLETOSIMPLES_USER_AGENT', nil)
      @custom_headers = {}
      @cache = nil
      @debug = ENV.fetch('BOLETOSIMPLES_DEBUG', nil)
    end

    def base_uri
      BASE_URI[@environment]
    end

    def api_token?
      !@api_token.nil?
    end

    def debug?
      !@debug.nil?
    end

    def setup_her
      Her::API.setup url: base_uri do |c|
        # Request
        c.use BoletoSimples::Middleware::UserAgent
        c.use BoletoSimples::Middleware::Bearer if api_token?
        c.use BoletoSimples::Middleware::CustomHeaders
        c.use Faraday::Request::Multipart
        c.use FaradayMiddleware::EncodeJson
        c.use Her::Middleware::AcceptJSON
        c.use Faraday::HttpCache, store: cache, serializer: Marshal unless cache.nil?

        # Response
        c.use BoletoSimples::Middleware::Debug if debug?
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
