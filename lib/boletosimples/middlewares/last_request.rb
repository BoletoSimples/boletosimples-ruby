module BoletoSimples
  module Middleware
    class LastRequest < Faraday::Response::Middleware
      def on_complete(env)
        BoletoSimples.last_request = BoletoSimples::LastRequest.new(env)
      end
    end
  end
end