# frozen_string_literal: true

module BoletoSimples
  module Middleware
    class CustomHeaders < Faraday::Middleware
      def call(env)
        env[:request_headers].merge!(BoletoSimples.configuration.custom_headers)
        @app.call(env)
      end
    end
  end
end
