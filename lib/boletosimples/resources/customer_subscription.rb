module BoletoSimples
  class CustomerSubscription < BaseModel

    def next_charge
      self.class.request(:_method => :post, :_path => self.class.build_request_path('customer_subscription_subscriptions/:id/next_charge', {self.class.primary_key => id})) do |parsed_data, response|
        assign_attributes(self.class.parse(parsed_data[:data])) if parsed_data[:data].any?
        @metadata = parsed_data[:metadata]
        @response_errors = parsed_data[:errors]
        @response = response
      end
      return @response.success?
    end
  end
end