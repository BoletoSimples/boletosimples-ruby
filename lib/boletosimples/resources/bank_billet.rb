# frozen_string_literal: true

module BoletoSimples
  class BankBillet < BaseModel
    custom_put :pay, :cancel
  end
end
