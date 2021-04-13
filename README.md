# Boleto Simples Ruby

[![Gem Version](http://img.shields.io/gem/v/boletosimples.svg)][gem]
[![Build Status](http://img.shields.io/travis/BoletoSimples/boletosimples-ruby.svg)][travis]

[gem]: https://rubygems.org/gems/boletosimples
[travis]: http://travis-ci.org/BoletoSimples/boletosimples-ruby

Biblioteca Ruby para acessar informações do [Boleto Simples](http://boletosimples.com.br) através da [API](http://api.boletosimples.com.br).

## Instalação

Adicione a linha a baixo no seu Gemfile:

    gem 'boletosimples'

Execute:

    $ bundle install

Ou instale você mesmo:

    $ gem install boletosimples

## Configuração

Saiba mais sobre o [Token de API ](https://api.boletosimples.com.br/authentication/token/)

```ruby
require 'boletosimples'

BoletoSimples.configure do |c|
  c.environment = :production # defaut :sandbox
  # production - https://boletosimples.com.br/conta/api/tokens
  # sandbox - https://sandbox.boletosimples.com.br/conta/api/tokens
  c.api_token = 'api-token'
  c.user_agent = 'email@minhaempresa.com.br' #Colocar um e-mail válido para contatos técnicos relacionado ao uso da API.
end
```

### Variáveis de ambiente

Você também pode configurar as variáveis de ambiente a seguir e não será necessário chamar `BoletoSimples.configure`

```bash
ENV['BOLETOSIMPLES_ENV']
ENV['BOLETOSIMPLES_API_TOKEN']
```

### Configurando cache

É altamente recomendável utilizar o cache para evitar chegar no [limite de requisições](http://api.boletosimples.com.br/#limite-de-requisicoes)

Para isso recomendamos a utilização da gem [Dalli](https://github.com/mperham/dalli)

Exemplo:

```ruby
  require 'dalli'

  BoletoSimples.configure do |c|
    c.cache = ActiveSupport::Cache.lookup_store(:dalli_store, ['localhost:11211'], namespace: 'boletosimples_client', compress: true)
  end
```

## Exemplos

### Boletos Bancários

```ruby
# Criar um boleto
@bank_billet = BoletoSimples::BankBillet.create(
  amount: 9.01,
  description: 'Despesas do contrato 0012',
  expire_at: '2014-01-01',
  customer_address: 'Rua quinhentos',
  customer_address_complement: 'Sala 4',
  customer_address_number: '111',
  customer_city_name: 'Rio de Janeiro',
  customer_cnpj_cpf: '012.345.678-90',
  customer_email: 'cliente@example.com',
  customer_neighborhood: 'Sao Francisco',
  customer_person_name: 'Joao da Silva',
  customer_person_type: 'individual',
  customer_phone_number: '2112123434',
  customer_state: 'RJ',
  customer_zipcode: '12312-123'
)

# Criar um novo boleto instanciando o objeto
@bank_billet = BoletoSimples::BankBillet.new(amount: 199.99, expire_at: '2020-01-01')
@bank_billet.description = 'Cobrança XPTO'
@bank_billet.save

# Mensagens de erro na criação do boleto
@bank_billet = BoletoSimples::BankBillet.create(amount: 199.99)
@bank_billet.response_errors
  # {:expire_at=>["não pode ficar em branco", "não é uma data válida"], :customer_person_name=>["não pode ficar em branco"], :customer_cnpj_cpf=>["não pode ficar em branco", "não é um CPNJ ou CPF válido"], :description=>["não pode ficar em branco"], :customer_zipcode=>["não pode ficar em branco"]

# Pegar informações de um boleto
@bank_billet = BoletoSimples::BankBillet.find(1) # onde 1 é o id do boleto.

 # Se o não for encontrado nenhum boleto com o id informado, uma exceção será levantada com a mensagem:
 # Couldn't find BankBillet with 'id'=1

# Listar os boletos
@bank_billets = BoletoSimples::BankBillet.all(page: 1, per_page: 50)
@bank_billets.each do |bank_billet|
  puts bank_billet.attributes
end

# Cancelar um boleto
@bank_billet = BoletoSimples::BankBillet.find(1)
@bank_billet.cancel

```

### Clientes

```ruby
# Criar um cliente
@customer = BoletoSimples::Customer.create(
  person_name: "Joao da Silva",
  cnpj_cpf: "012.345.678-90",
  email: "cliente@example.com",
  address: "Rua quinhentos",
  city_name: "Rio de Janeiro",
  state: "RJ",
  neighborhood: "bairro",
  zipcode: "12312-123",
  address_number: "111",
  address_complement: "Sala 4",
  phone_number: "2112123434"
)

# Mensagens de erro na criação do cliente
@customer = BoletoSimples::Customer.new(person_name: '')
@customer.response_errors
  # {:person_name=>["não pode ficar em branco"], :cnpj_cpf=>["não pode ficar em branco"], :zipcode=>["não pode ficar em branco"]}

# Listar os clientes
@customers = BoletoSimples::Customer.all(page: 1, per_page: 50)
@customers.each do |customer|
  puts customer.attributes
end

# Atualizar um cliente
@customer = BoletoSimples::Customer.find(1)
@customer.person_name = 'Novo nome'
@customer.save
```
