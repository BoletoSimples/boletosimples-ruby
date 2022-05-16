# frozen_string_literal: true

module BoletoSimples
  class LastRequest
    attr_reader :body, :request_headers, :response_headers, :total, :ratelimit_limit, :ratelimit_remaining, :links

    def initialize(env)
      @env = env
    end

    def body
      @body ||= @env[:body][:data]
    end

    def request_headers
      @request_headers ||= @env.request_headers
    end

    def response_headers
      @response_headers ||= @env[:response_headers]
    end

    def total
      @total ||= @env[:response_headers]['total'].to_i
    end

    def ratelimit_limit
      ratelimit_limit ||= @env[:response_headers]['x-ratelimit-limit'].to_i
    end

    def ratelimit_remaining
      @ratelimit_remaining ||= @env[:response_headers]['x-ratelimit-remaining'].to_i
    end

    def links
      return @links unless @links.nil?

      link_header = @env[:response_headers]['link']
      return {} if link_header.nil?

      @links = {}
      link_header.split(', ').each do |link|
        key = /rel="(.*)"/.match(link)[1]
        value = /<(.*)>/.match(link)[1]
        @links[key] = value
      end
      @links.symbolize_keys!
    end
  end
end
