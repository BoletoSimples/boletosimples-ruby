# frozen_string_literal: true

require 'her'
require 'faraday_middleware'
require 'faraday-http-cache'
require 'boletosimples/version'

module BoletoSimples
  autoload :Configuration, 'boletosimples/configuration'
  autoload :ResponseError, 'boletosimples/response_error'
  autoload :LastRequest, 'boletosimples/last_request'

  autoload :BankBillet, 'boletosimples/resources/bank_billet'
  autoload :BankBilletAccount, 'boletosimples/resources/bank_billet_account'
  autoload :BankBilletDischarge, 'boletosimples/resources/bank_billet_discharge'
  autoload :BankBilletPayment, 'boletosimples/resources/bank_billet_payment'
  autoload :BankBilletRemittance, 'boletosimples/resources/bank_billet_remittance'
  autoload :Event, 'boletosimples/resources/event'
  autoload :EmailDelivery, 'boletosimples/resources/email_delivery'
  autoload :SmsDelivery, 'boletosimples/resources/sms_delivery'
  autoload :Customer, 'boletosimples/resources/customer'
  autoload :CustomerImport, 'boletosimples/resources/customer_import'
  autoload :CustomerSubscription, 'boletosimples/resources/customer_subscription'
  autoload :CustomerSubscriptionImport, 'boletosimples/resources/customer_subscription_import'
  autoload :Installment, 'boletosimples/resources/installment'
  autoload :Transaction, 'boletosimples/resources/transaction'
  autoload :Remittance, 'boletosimples/resources/remittance'
  autoload :Discharge, 'boletosimples/resources/discharge'
  autoload :BaseModel, 'boletosimples/resources/base_model'
  autoload :Webhook, 'boletosimples/resources/webhook'
  autoload :WebhookDelivery, 'boletosimples/resources/webhook_delivery'

  module Middleware
    autoload :UserAgent, 'boletosimples/middlewares/user_agent'
    autoload :RaiseError, 'boletosimples/middlewares/raise_error'
    autoload :LastRequest, 'boletosimples/middlewares/last_request'
    autoload :Debug, 'boletosimples/middlewares/debug'
    autoload :Bearer, 'boletosimples/middlewares/bearer'
  end

  class << self
    attr_accessor :configuration, :last_request

    def configure
      @configuration = Configuration.new
      yield(configuration) if block_given?
      configuration.setup_her # after changing configuration gem her should be configured
    end
  end
end

BoletoSimples.configure
