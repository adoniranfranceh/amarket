ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'

# Adicione outras configurações específicas do Rails ou do RSpec, se necessário.

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true

  # Adicione outras configurações do RSpec, se necessário.
end
