require 'rubygems'
require 'bundler/setup'
require 'dotenv'
require 'csv'

Bundler.require(:default)

Dotenv.load

DeskApi.configure do |config|
  # basic authentication
  config.username = ENV['DESK_USERNAME']
  config.password = ENV['DESK_PASSWORD']
  config.endpoint = ENV['DESK_ENDPOINT']
end

CSVFiles = Dir["./CSV_Files/*"]

CSV.foreach(CSVFiles.grep(/company/)[0], headers: true) do |row|
  new_company = DeskApi.companies.create({
                                           name: row["Name"],
                                           external_id: row["Id"]

  })
end
