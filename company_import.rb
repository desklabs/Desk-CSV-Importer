require 'rubygems'
require 'bundler/setup'
require 'dotenv'
require 'csv'

Bundler.require(:default)

Dotenv.load

Rollbar.configure do |config|
  config.access_token = "c917f3b9237848a88f5cf0dfb306e76c"
  # Other Configuration Settings
end

Rollbar.debug("Running Script")

######
# Configure the Desk.com connection using the settings in the .env file.
######
DeskApi.configure do |config|
  # basic authentication
  config.username = ENV['DESK_USERNAME']
  config.password = ENV['DESK_PASSWORD']
  config.endpoint = ENV['DESK_ENDPOINT']
end

#######
# We are going to start by importing companies from this file.
# #####
puts "Starting Companies"
company_csv_file = "./CSV_Files/YY_MM_DD_company.csv"

######
# Since our cusrtomer CSV file only contains our Company ID from our old system,
# we need to store each company's name and ID into an array for later use in customers
######
company_hash = {}

######
# Loop through the company CSV file defined above
######
CSV.foreach(company_csv_file, headers: true) do |row|
  break
  # Store the name and id into our hash from before
  company_hash[row["Id"]] = row["Name"]
  begin
    new_company = DeskApi.companies.create({
                                             name: row["Name"],
                                             external_id: row["Id"]

    })
  rescue DeskApi::Error => e
    Rollbar.error(e, e.errors, row["Name"])
  end
end


#######
# Now, we will import our customers.  We will be using the hash form above to look
# up the company name's for our customers.
# #####
puts "Starting Customers"
company_csv_file = "./CSV_Files/YY_MM_DD_customer.csv"


CSV.foreach(company_csv_file, headers: true) do |row|

  data = {
    first_name: row["FirstName"],
    last_name: row["LastName"],
    company: company_hash[row["CompanyId"]]
  }

  emails_array = []
  row["Emails"].split(',').each do |email|
    emails_array << {"type": "work","value": email}
  end
  data[:emails] = emails_array
  begin
    new_customer = DeskApi.customers.create(data)
  rescue DeskApi::Error => e
    Rollbar.error(e, e.errors, emails_array.to_s)
  end
end
