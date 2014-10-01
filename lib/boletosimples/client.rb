require 'httparty'
require 'multi_json'

module BoletoSimples
  class Client
    include HTTParty

    PRODUCTION_BASE_URI = 'https://boletosimples.com.br/api/v1'
    SANDBOX_BASE_URI = 'https://staging.boletosimples.com.br/api/v1'

    def initialize(access_token, options = {})
      @access_token = access_token

      # defaults
      @production = options.delete(:production)
      @base_uri = options[:base_uri] || (@production ? PRODUCTION_BASE_URI : SANDBOX_BASE_URI)
      @user_agent = options.delete(:user_agent)

      options[:format] ||= :json
      options.each do |k, v|
        self.class.send k, v
      end
    end

    # Users
    def userinfo(options = {})
      get '/userinfo', options
    end

    # Transactions
    def transactions(page = 1, options = {})
      get '/transactions', { page: page }.merge(options)
    end

    # Customers
    def customers(page = 1, options = {})
      get '/customers', { page: page }.merge(options)
    end

    def create_customer(options = {})
      post '/customers', options
    end

    def customer(id = 1, options = {})
      get "/customers/#{id}", options
    end

    # Bank Billets
    def bank_billets(page = 1, options = {})
      get '/bank_billets', { page: page }.merge(options)
    end

    def create_bank_billet(options = {})
      post '/bank_billets', options
    end

    def bank_billet(id = 1, options = {})
      get "/bank_billets/#{id}", options
    end

    # Wrappers for the main HTTP verbs

    def get(path, options = {})
      http_verb :get, path, options
    end

    def post(path, options = {})
      http_verb :post, path, options
    end

    def put(path, options = {})
      http_verb :put, path, options
    end

    def delete(path, options = {})
      http_verb :delete, path, options
    end

    def http_verb(verb, path, options = {})
      request_options = { body: options.to_json }
      request_options[:headers] = {
        'Content-Type' => 'application/json',
        'User-Agent' => @user_agent
      }
      request_options[:query] ||= {}
      request_options[:query].merge!(access_token: @access_token)

      uri = "#{@base_uri}#{path}"
      response = self.class.send(verb, uri, request_options)
      JSON.parse(response.body)
    end
  end
end
