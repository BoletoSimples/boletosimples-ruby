# -*- encoding: utf-8 -*-
require 'oauth2'

module BoletoSimples
  class OAuthClient < Client
    # Initializes a BoletoSimples Client using OAuth 2.0 credentials
    #
    # @param [String] client_id this application's BoletoSimples OAuth2 CLIENT_ID
    # @param [String] client_secret this application's BoletoSimples OAuth2 CLIENT_SECRET
    # @param [Hash] user_credentials OAuth 2.0 credentials to use
    # @option user_credentials [String] access_token Must pass either this or token
    # @option user_credentials [String] token Must pass either this or access_token
    # @option user_credentials [String] refresh_token Optional
    # @option user_credentials [Integer] expires_at Optional
    # @option user_credentials [Integer] expires_in Optional
    #
    # Please note access tokens will be automatically refreshed when expired
    # Use the credentials method when finished with the client to retrieve up-to-date credentials
    def initialize(client_id, client_secret, user_credentials, options={})
      @production = options.delete(:production)
      @base_uri = options[:base_uri] || (@production ? PRODUCTION_BASE_URI : SANDBOX_BASE_URI)
      client_opts = {
        :site => @base_uri,
        :authorize_url => options[:authorize_url] || "#{@base_uri}/oauth/authorize",
        :token_url => options[:token_url] || "#{@base_uri}/oauth/token",
        :raise_errors => false
      }
      @user_agent = options.delete(:user_agent)
      @oauth_client = OAuth2::Client.new(client_id, client_secret, client_opts)
      token_hash = user_credentials.dup
      token_hash[:access_token] ||= token_hash[:token]
      token_hash.delete :expires
      raise "No access token provided" unless token_hash[:access_token]
      @oauth_token = OAuth2::AccessToken.from_hash(@oauth_client, token_hash)
    end

    def http_verb(verb, path, options={})
      path = remove_leading_slash(path)
      request_options = {headers: {
        "Accept-Charset" => "UTF-8",
        "Content-Type" => "application/json",
        "User-Agent" => @user_agent
      }, body: options.to_json}

      response = oauth_token.request(verb, path, request_options)
      return JSON.parse(response.body)
    end

    def refresh!
      raise "Access token not initialized." unless @oauth_token
      @oauth_token = @oauth_token.refresh!
    end

    def oauth_token
      raise "Access token not initialized." unless @oauth_token
      refresh! if @oauth_token.expired?
      @oauth_token
    end

    def credentials
      @oauth_token.to_hash
    end

    private

    def remove_leading_slash(path)
      path.sub(/^\//, '')
    end
  end
end
