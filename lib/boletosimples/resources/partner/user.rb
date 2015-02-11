module BoletoSimples
  module Partner
    class User < BoletoSimples::BaseModel
      collection_path "partner/users"
    end
  end
end