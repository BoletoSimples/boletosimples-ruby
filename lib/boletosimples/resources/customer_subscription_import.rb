# frozen_string_literal: true

module BoletoSimples
  class CustomerSubscriptionImport < BaseModel
    collection_path 'imports/customer_subscriptions'
    resource_path 'imports/customer_subscriptions/:id'
  end
end
