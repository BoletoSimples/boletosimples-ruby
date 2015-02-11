# encoding: UTF-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'boletosimples/version'

Gem::Specification.new do |gem|
  gem.name          = 'boletosimples'
  gem.version       = BoletoSimples::VERSION
  gem.authors       = ['Kivanio Barbosa', 'Rafael Lima', 'Thiago Belem']
  gem.email         = ['kivanio@gmail.com', 'contato@rafael.adm.br', 'contato@thiagobelem.net']
  gem.description   = 'An easy way to charge by bank billet.'
  gem.summary       = 'An easy way to charge by bank billet.'
  gem.homepage      = 'https://boletosimples.com.br'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(/^bin\//).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(/^(test|spec|features)\//)
  gem.require_paths = ['lib']

  gem.required_ruby_version = '>= 1.9'

  # Gems that must be intalled for boletosimples to work
  gem.add_dependency 'her', '~> 0.7.3'
  gem.add_dependency 'faraday_middleware', '~> 0.9.1'
  gem.add_dependency 'simple_oauth', '~> 0.3.1'
  # gem.add_dependency 'httparty', '~> 0.13.1'
  # gem.add_dependency 'multi_json', '~> 1.10.1'
  # gem.add_dependency 'oauth2', '~> 1.0.0'

  # Gems that must be installed for boletosimples to compile and build
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rspec', '~> 3.1'
  gem.add_development_dependency 'vcr', '~> 2.9'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'coveralls'
  gem.add_development_dependency 'codeclimate-test-reporter'
end
