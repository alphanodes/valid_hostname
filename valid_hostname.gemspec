# frozen_string_literal: true

lib = File.expand_path 'lib', __dir__
$LOAD_PATH.unshift lib unless $LOAD_PATH.include? lib
require 'valid_hostname/version'

Gem::Specification.new do |spec|
  spec.name = 'valid_hostname'
  spec.version = ValidHostname::VERSION
  spec.metadata = { 'rubygems_mfa_required' => 'true' }

  spec.authors = ['Kim Nøgaard', 'Alexander Meindl']
  spec.description = 'Extension to ActiveModel for validating hostnames'
  spec.summary = 'Checks for valid hostnames'
  spec.email = ['jasen@jasen.dk', 'a.meindl@alphanodes.com']
  spec.homepage = 'https://github.com/AlphaNodes/valid_hostname'
  spec.licenses = ['MIT']
  spec.required_ruby_version = '>= 2.7'

  spec.files         = `git ls-files`.split "\n"
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activemodel'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'debug' if ENV['ENABLE_DEBUG']
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'rubocop-rspec'
end
