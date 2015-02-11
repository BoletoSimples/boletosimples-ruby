module BoletoSimples
  class BaseModel
    include Her::Model

    parse_root_in_json true
    include_root_in_json true
  end
end