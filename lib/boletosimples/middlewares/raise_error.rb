module BoletoSimples
  module Middleware
    class RaiseError < Faraday::Response::Middleware
      def on_complete(env)
        status = env[:status].to_i
        klass = BoletoSimples::ResponseError
        raise klass.new(env) if (400..599).include?(status) and env[:body][:data][:error]
      end
    end
  end
end