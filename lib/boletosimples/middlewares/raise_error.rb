# frozen_string_literal: true

module BoletoSimples
  module Middleware
    class RaiseError < Faraday::Response::Middleware
      def on_complete(env)
        status = env[:status].to_i
        klass = BoletoSimples::ResponseError
        raise klass, env if (400..599).include?(status) && env[:body][:data][:error]
      end
    end
  end
end
