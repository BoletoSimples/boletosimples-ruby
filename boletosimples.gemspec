# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'boletosimples/version'

Gem::Specification.new do |gem|
  gem.name          = 'boletosimples'
  gem.version       = BoletoSimples::VERSION
  gem.authors       = ['Kivanio Barbosa', 'Rafael Lima', 'Thiago Belem']
  gem.email         = ['kivanio@gmail.com', 'contato@rafael.adm.br', 'contato@thiagobelem.net']
  gem.description   = 'Boleto Simples API wrapper.'
  gem.summary       = 'Boleto Simples API wrapper.'
  gem.homepage      = 'https://github.com/BoletoSimples/boletosimples-ruby'

  gem.files         = Dir['lib/**/*', 'LICENSE.txt', 'README.md', 'CHANGELOG.md']
  gem.test_files    = Dir['spec/**/*']

  gem.require_paths = ['lib']

  # Gems that must be intalled for boletosimples to work
  gem.add_dependency 'faraday-http-cache', '~> 2.2.0'
  gem.add_dependency 'faraday_middleware', '~> 1.0'
  gem.add_dependency 'her', '~> 1.1'

  # Gems that must be installed for boletosimples to compile and build
  gem.add_development_dependency 'fuubar'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rubocop'
  gem.add_development_dependency 'rubocop-packaging'
  gem.add_development_dependency 'rubocop-performance'
  gem.add_development_dependency 'rubocop-rake'
  gem.add_development_dependency 'rubocop-rspec'
  gem.add_development_dependency 'solargraph'
  gem.add_development_dependency 'stub_env'
  gem.add_development_dependency 'test-prof'
  gem.add_development_dependency 'vcr'
  gem.add_development_dependency 'webmock'
end
