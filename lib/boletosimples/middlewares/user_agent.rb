# frozen_string_literal: true

module BoletoSimples
  module Middleware
    class UserAgent < Faraday::Middleware
      def call(env)
        env[:request_headers]['User-Agent'] = BoletoSimples.configuration.user_agent
        @app.call(env)
      end
    end
  end
end
