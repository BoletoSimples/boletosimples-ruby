# encoding: utf-8
module BoletoSimples

  class Configuration
    attr_accessor :environment, :user_agent, :application_id, :application_secret, :access_token


    BASE_URI = {
      sandbox: 'https://sandbox.boletosimples.com.br/api/v1',
      production: 'https://boletosimples.com.br/api/v1'
    }

    def initialize
      @environment = :sandbox
      @user_agent = "BoletoSimples Ruby Client v#{BoletoSimples::VERSION}"
      @application_id = nil
      @application_secret = nil
      @access_token = nil
    end

    def base_uri
      BASE_URI[@environment]
    end
  end

end