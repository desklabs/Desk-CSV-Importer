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

CSV.foreach(CSVFiles.grep(/customer/)[0], headers: true) do |row|

  binding.pry

  new_company = DeskApi.customers.create({
                                           first_name: row["First Name"],
                                           last_name: row["Last Name"],
                                           title: row["Title"],
                                           company: row["Id"],
                                           emails:

  })
end
