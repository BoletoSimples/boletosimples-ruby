require 'httparty'
require 'multi_json'

module BoletoSimples
  class Client
    include HTTParty

    BASE_URI = 'https://boletosimples.com/api/v1'

    def initialize(username, password, options={})
      @username = username
      @password = password

      # defaults
      options[:base_uri] ||= BASE_URI
      @base_uri = options[:base_uri]
      @user_agent = options.delete(:user_agent)

      options[:format] ||= :json
      options.each do |k, v|
        self.class.send k, v
      end
    end

    # Users

    def userinfo options={}
      get '/userinfo', options
    end

    # Users
    def partner_create_user options={}
      post '/partner/users', options
    end

    # Transactions

    def transactions page=1, options ={}
      get '/transactions', {page: page}.merge(options)
    end

    # Customers
    def customers page=1, options ={}
      get '/customers', {page: page}.merge(options)
    end

    def create_customer options ={}
      post '/customers', options
    end

    def customer id=1, options ={}
      get "/customers/#{id}", options
    end

    # Bank Billets
    def bank_billets page=1, options ={}
      get '/bank_billets', {page: page}.merge(options)
    end

    def create_bank_billet options ={}
      post '/bank_billets', options
    end

    def bank_billet id=1, options ={}
      get "/bank_billets/#{id}", options
    end

    # Wrappers for the main HTTP verbs

    def get(path, options={})
      http_verb :get, path, options
    end

    def post(path, options={})
      http_verb :post, path, options
    end

    def put(path, options={})
      http_verb :put, path, options
    end

    def delete(path, options={})
      http_verb :delete, path, options
    end

    def http_verb(verb, path, options={})
      request_options = {body: options.to_json}
      headers = {
        "Content-Type" => "application/json",
        "User-Agent" => @user_agent
      }
      request_options[:headers] = headers
      request_options[:basic_auth] = {:username => @username, :password => @password}

      result = self.class.send(verb, path, request_options)
      result = JSON.parse(result.body)
      result
    end
  end
end
