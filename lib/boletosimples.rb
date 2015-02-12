require 'her'
require 'faraday_middleware'
require 'boletosimples/version'

module BoletoSimples
  autoload :Configuration, 'boletosimples/configuration'
  autoload :ResponseError, 'boletosimples/response_error'
  autoload :BankBillet, 'boletosimples/resources/bank_billet'
  autoload :Customer, 'boletosimples/resources/customer'
  autoload :Transaction, 'boletosimples/resources/transaction'
  autoload :BaseModel, 'boletosimples/resources/base_model'

  module Partner
    autoload :User, 'boletosimples/resources/partner/user'
  end

  module Middleware
    autoload :UserAgent, 'boletosimples/middlewares/user_agent'
    autoload :RaiseError, 'boletosimples/middlewares/raise_error'
  end

  class << self
    attr_accessor :configuration

    def configure
      @configuration = Configuration.new
      yield(configuration) if block_given?
      configuration.setup_her # after changing configuration gem her should be configured
    end
  end

end

BoletoSimples.configure