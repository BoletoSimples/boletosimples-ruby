# frozen_string_literal: true

module BoletoSimples
  # BoletoSimples::ResponseError
  # Exception that gets raised if the response is an error (4xx or 5xx)
  #
  # Formats a readable error message including HTTP status, method and requested URL
  #
  # Examples:
  #
  #   BoletoSimples::BankBillet.all
  #   BoletoSimples::ResponseError: 401 POST https://sandbox.boletosimples.com.br/api/v1/bank_billets
  #
  #   begin
  #     BoletoSimples::BankBillet.all
  #   rescue BoletoSimples::ResponseError => response
  #     response.status # => 401
  #     response.method # => "GET"
  #     response.url # => "https://sandbox.boletosimples.com.br/api/v1/bank_billets"
  #     response.body # => "{"error":"Você precisa se logar ou registrar antes de prosseguir."}"
  #     response.error_message # => "Você precisa se logar ou registrar antes de prosseguir."
  #   end
  #
  class ResponseError < StandardError
    attr_reader :response, :body, :status, :method, :url, :error_message

    def initialize(response = nil)
      @response = response

      @body = response[:body][:data]
      @status = response[:status].to_i
      @method = response[:method].to_s.upcase
      @url = response[:url]

      errors = response[:body][:errors]
      @error_message = errors.first[:title] unless errors.blank?

      super
    end

    def to_s
      msg = ''
      msg += "#{status} #{method} #{url}"
      msg << " (#{error_message})" unless error_message.blank?
      msg
    end
  end
end
