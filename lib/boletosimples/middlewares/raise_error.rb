# frozen_string_literal: true

module BoletoSimples
  module Middleware
    class RaiseError < Faraday::Response::Middleware
      def on_complete(env)
        status = env[:status].to_i
        return if status == 422

        klass = BoletoSimples::ResponseError
        if (400..599).cover?(status) && env[:body][:errors]
          puts env.inspect
          raise klass, env
        end
      end
    end
  end
end
