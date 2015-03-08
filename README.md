# Boleto Simples

[![Gem Version](http://img.shields.io/gem/v/boletosimples.svg)][gem]
[![Build Status](http://img.shields.io/travis/BoletoSimples/boletosimples-ruby.svg)][travis]
[![Dependency Status](http://img.shields.io/gemnasium/BoletoSimples/boletosimples-ruby.svg)][gemnasium]
[![Code Climate](http://img.shields.io/codeclimate/github/BoletoSimples/boletosimples-ruby.svg)][codeclimate]
[![Coverage Status](http://img.shields.io/coveralls/BoletoSimples/boletosimples-ruby.svg)][coveralls]

[gem]: https://rubygems.org/gems/boletosimples
[travis]: http://travis-ci.org/BoletoSimples/boletosimples-ruby
[gemnasium]: https://gemnasium.com/BoletoSimples/boletosimples-ruby
[codeclimate]: https://codeclimate.com/github/BoletoSimples/boletosimples-ruby
[coveralls]: https://coveralls.io/r/BoletoSimples/boletosimples-ruby

Esta gem inclui todos os métodos disponíveis na [Boleto Simples JSON API](http://api.boletosimples.com.br).

## Instalação

Adicione a linha a baixo no seu Gemfile:

    gem 'boletosimples'

Execute:

    $ bundle install

Ou instale você mesmo:

    $ gem install boletosimples

## Configuração

```ruby
require 'boletosimples'

BoletoSimples.configure do |c|
  c.environment = :production # defaut :sandbox
  c.access_token = 'access-token'
end
```

### Variáveis de ambiente

Você também pode configurar as variáveis de ambiente a seguir e não será necessário chamar `BoletoSimples.configure`

```bash
ENV['BOLETOSIMPLES_ENV']
ENV['BOLETOSIMPLES_APP_ID']
ENV['BOLETOSIMPLES_APP_SECRET']
ENV['BOLETOSIMPLES_ACCESS_TOKEN']
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
@bank_billet = BoletoSimples::BankBillet.create({
  amount: '9,01',
  description: 'Despesas do contrato 0012',
  expire_at: '2014-01-01',
  customer_address: 'Rua quinhentos',
  customer_address_complement: 'Sala 4',
  customer_address_number: '111',
  customer_city_name: 'Rio de Janeiro',
  customer_cnpj_cpf: '012.345.678-90',
  customer_email: 'cliente@bom.com',
  customer_neighborhood: 'Sao Francisco',
  customer_person_name: 'Joao da Silva',
  customer_person_type: 'individual',
  customer_phone_number: '2112123434',
  customer_state: 'RJ',
  customer_zipcode: '12312-123',
  notification_url: 'http://example.com.br/notify'
})

# Criar um novo boleto instanciando o objeto
@bank_billet = BoletoSimples::BankBillet.new(amount: '199,99', expire_at: '2020-01-01')
@bank_billet.description = 'Cobrança XPTO'
@bank_billet.save

# Mensagens de erro na criação do boleto
@bank_billet = BoletoSimples::BankBillet.create(amount: 199.99)
@bank_billet.response_errors
  # {:expire_at=>["não pode ficar em branco", "não é uma data válida"], :customer_person_name=>["não pode ficar em branco"], :customer_cnpj_cpf=>["não pode ficar em branco", "não é um CPNJ ou CPF válido"], :description=>["não pode ficar em branco"], :customer_zipcode=>["não pode ficar em branco"], :amount=>["está em um formato de moeda inválido"]

# Pegar informações de um boleto
@bank_billet = BoletoSimples::BankBillet.find(1) # onde 1 é o id do boleto.

 # Se o não for encontrado nenhum boleto com o id informado, uma exceção será levantada com a mensagem:
 # Couldn't find BankBillet with 'id'=1

# Listar os boletos
@bank_billets = BoletoSimples::BankBillet.all(page: 1, per_page: 50)
@bank_billet.each do |bank_billet|
  puts bank_billet.id
end

 # Após realizar a chamada na listagem, você terá acesso aos seguintes dados:

BoletoSimples.last_request.total # número total de boletos
BoletoSimples.last_request.links[:first] # url da primeira página
BoletoSimples.last_request.links[:prev] # url da página anterior
BoletoSimples.last_request.links[:next] # url da próxima página
BoletoSimples.last_request.links[:last] # url da última página

# Cancelar um boleto
@bank_billet = BoletoSimples::BankBillet.find(1)
@bank_billet.cancel

```

### Clientes

```ruby
# Criar um cliente
@customer = BoletoSimples::Customer.create({
  person_name: "Joao da Silva",
  cnpj_cpf: "012.345.678-90",
  email: "cliente@bom.com",
  address: "Rua quinhentos",
  city_name: "Rio de Janeiro",
  state: "RJ",
  neighborhood: "bairro",
  zipcode: "12312-123",
  address_number: "111",
  address_complement: "Sala 4",
  phone_number: "2112123434"
})

# Mensagens de erro na criação do cliente
@customer = BoletoSimples::Customer.new(person_name: '')
@customer.response_errors
  # {:person_name=>["não pode ficar em branco"], :cnpj_cpf=>["não pode ficar em branco"], :zipcode=>["não pode ficar em branco"]}

# Listar os clientes
@customers = BoletoSimples::Customer.all(page: 1, per_page: 50)
@customers.each do |customer|
  puts customer.id
end

 # Após realizar a chamada na listagem, você terá acesso aos seguintes dados:

BoletoSimples.last_request.total # número total de clientes
BoletoSimples.last_request.links[:first] # url da primeira página
BoletoSimples.last_request.links[:prev] # url da página anterior
BoletoSimples.last_request.links[:next] # url da próxima página
BoletoSimples.last_request.links[:last] # url da última página

# Atualizar um cliente
@customer = BoletoSimples::Customer.find(1)
@customer.person_name = 'Novo nome'
@customer.save
```

### Extrato

```ruby
# Listar todas as transações
@transactions = BoletoSimples::Transaction.all
@transactions.each do |transaction|
  puts transaction.id
end
```

### Extras

```ruby
# Dados do usuário logado
@userinfo = BoletoSimples::Extra.userinfo
```

## OAuth 2.0 Authentication (para acessar as contas dos usuários)

Comece [solicitando um cadastro de OAuth 2.0 application](http://suporte.boletosimples.com.br)

