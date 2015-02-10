require 'json'
require 'httparty'
require 'multi_json'
require 'boletosimples/version'
require 'boletosimples/configuration'
require 'boletosimples/client'
require 'boletosimples/oauth_client'
require 'oauth2_patch'

module BoletoSimples
  def self.configuration
    @configuration ||=  Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end
end