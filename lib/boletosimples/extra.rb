# frozen_string_literal: true

module BoletoSimples
  class Extra
    def self.userinfo
      response = Her::API.default_api.connection.get '/api/v1/userinfo.json'
      response.body[:data]
    end
  end
end
