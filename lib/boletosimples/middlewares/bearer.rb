module BoletoSimples
  module Middleware
    class Bearer < Faraday::Middleware
      def call(env)
        env[:request_headers]['Authorization'] = "Bearer #{BoletoSimples.configuration.api_token}"
        @app.call(env)
      end
    end
  end
end
