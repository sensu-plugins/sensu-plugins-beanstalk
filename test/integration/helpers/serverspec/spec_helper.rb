# frozen_string_literal: true

require 'busser/rubygems'
Busser::RubyGems.install_gem('beaneater', '~> 0.3.3')

require 'serverspec'
set :backend, :exec
