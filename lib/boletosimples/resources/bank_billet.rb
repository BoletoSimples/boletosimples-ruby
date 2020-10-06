# frozen_string_literal: true

module BoletoSimples
  class BankBillet < BaseModel
    def cancel
      self.class.request(_method: :put, _path: self.class.build_request_path('bank_billets/:id/cancel', { self.class.primary_key => id })) do |parsed_data, response|
        assign_attributes(self.class.parse(parsed_data[:data])) if parsed_data[:data].any?
        @metadata = parsed_data[:metadata]
        @response_errors = parsed_data[:errors]
        @response = response
      end
      @response.success?
    end

    def pay
      self.class.request(_method: :put, _path: self.class.build_request_path('bank_billets/:id/pay', { self.class.primary_key => id })) do |parsed_data, response|
        assign_attributes(self.class.parse(parsed_data[:data])) if parsed_data[:data].any?
        @metadata = parsed_data[:metadata]
        @response_errors = parsed_data[:errors]
        @response = response
      end
      @response.success?
    end
  end
end
