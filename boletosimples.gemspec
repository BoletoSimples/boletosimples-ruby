# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'boletosimples/version'

Gem::Specification.new do |gem|
  gem.name          = 'boletosimples'
  gem.version       = BoletoSimples::VERSION
  gem.authors       = ['Kivanio Barbosa', 'Rafael Lima']
  gem.email         = ['kivanio@gmail.com', 'contato@rafael.adm.br']
  gem.description   = 'An easy way to charge by bank billet.'
  gem.summary       = 'An easy way to charge by bank billet.'
  gem.homepage      = 'http://api.boletosimples.com.br'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  # Gems that must be installed for sift to compile and build
  gem.add_development_dependency 'pry', '0.9.12.6'
  gem.add_development_dependency 'rspec', '~> 3.0.0'
  gem.add_development_dependency 'rake'

  # Gems that must be intalled for sift to work
  gem.add_dependency 'httparty', '>= 0.13.1'
  gem.add_dependency 'multi_json', '>= 1.10.1'
  gem.add_dependency 'oauth2', '~> 0.9.4'
end
