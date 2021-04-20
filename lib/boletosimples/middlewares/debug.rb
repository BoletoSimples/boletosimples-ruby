# frozen_string_literal: true

module BoletoSimples
  module Middleware
    class Debug < Faraday::Response::Middleware
      def initialize(app, logger = nil)
        super(app)
        @logger = logger || begin
          require 'logger'
          ::Logger.new($stdout)
        end
      end

      def on_complete(env)
        @logger.info "\n::#{env[:method].upcase} #{env[:url]}"
        @logger.info '  Request'
        env[:request_headers].each do |key, value|
          @logger.info "  -- #{key}: #{value}"
        end
        @logger.info '  Response'
        @logger.info "  -- Status: #{env[:status]}"
        env[:response_headers].each do |key, value|
          @logger.info "  -- #{key}: #{value}"
        end
        @logger.info '  Response body'
        @logger.info "  -- #{env[:body]} \n"
      end
    end
  end
end
