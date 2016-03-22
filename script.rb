require 'rubygems'
require 'bundler/setup'
require 'dotenv'
Bundler.require(:default)
Dotenv.load


DeskApi.configure do |config|
  # basic authentication
  config.username = ENV['DESK_USERNAME']
  config.password = ENV['DESK_PASSWORD']

  config.endpoint = ENV['DESK_ENDPOINT']
end

CSVFiles = Dir["./CSV_Files/*"]

binding.pry