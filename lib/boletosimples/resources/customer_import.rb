# frozen_string_literal: true

module BoletoSimples
  class CustomerImport < BaseModel
    collection_path 'imports/customers'
    resource_path 'imports/customers/:id'
  end
end
