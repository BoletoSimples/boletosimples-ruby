require 'her'
require 'faraday_middleware'
require 'faraday-http-cache'
require 'boletosimples/version'

module BoletoSimples
  autoload :Configuration, 'boletosimples/configuration'
  autoload :Extra, 'boletosimples/extra'
  autoload :ResponseError, 'boletosimples/response_error'
  autoload :LastRequest, 'boletosimples/last_request'

  autoload :BankBillet, 'boletosimples/resources/bank_billet'
  autoload :BankBilletAccount, 'boletosimples/resources/bank_billet_account'
  autoload :Customer, 'boletosimples/resources/customer'
  autoload :Transaction, 'boletosimples/resources/transaction'
  autoload :BaseModel, 'boletosimples/resources/base_model'

  module Partner
    autoload :User, 'boletosimples/resources/partner/user'
  end

  module Middleware
    autoload :UserAgent, 'boletosimples/middlewares/user_agent'
    autoload :RaiseError, 'boletosimples/middlewares/raise_error'
    autoload :LastRequest, 'boletosimples/middlewares/last_request'
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