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

  data = {
    first_name: row["FirstName"],
    last_name: row["LastName"],
    company: row["CompanyId"]
  }

  emails_array = []
  row["Emails"].split(',').each do |email|
    emails_array << {"type": "work","value": email}
  end
  data[:emails] = emails_array

  new_customer = DeskApi.customers.create(data)
  binding.pry
end
