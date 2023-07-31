ENV['RACK_ENV'] = 'test'

require 'capybara/rspec'
require 'capybara/dsl'
require 'rack/test'
require_relative '../server.rb'
require_relative '../database.rb'

Capybara.app = Sinatra::Application

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include Rack::Test::Methods

  config.before(:each) do
    Database.create
  end

  config.after(:each) do
    Database.drop
  end
end
