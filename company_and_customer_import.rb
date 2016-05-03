require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'logger'
Bundler.require(:default)

######
# Pull settings from the .env file.
######
Dotenv.load

######
# Setup our log files
######
company_error_log = Logger.new('company_error.log')
customer_error_log = Logger.new('customer_error.log')

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
#######
puts "Starting Companies"
company_csv_file = "./CSV_Files/companies.csv"

######
# Since our cusrtomer CSV file only contains our Company ID from our old system,
# we need to store each company's name and ID into an array for later use in customers
######
company_hash = {}

######
# Loop through the company CSV file defined above
######
CSV.foreach(company_csv_file, headers: true) do |row|

  # Store the name and id into our hash from before
  company_hash[row["Id"]] = row["Name"]

  # Build our data hash to for the new company
  data = {
    name: row["Name"],
    external_id: row["Id"],
    domains: row["domains"]
  }

  # look for our custom fields and add them to the data hash if found
  custom_fields = {}

  row.to_h.each do |key, value|
    if key.include? "custom_"
      custom_fields[key.gsub("custom_","").to_sym] = value unless value.nil?
    end
  end

  data[:custom_fields] = custom_fields unless custom_fields == {}


  #   # create a company for the row
  begin
    new_company = DeskApi.companies.create(data)
    # if it fails, log it in the error log
  rescue DeskApi::Error => e
    puts "Error creating company: #{row['Name']} - #{e.errors}"
    company_error_log.error "Error creating company: #{row['Name']} - #{e.errors}"
  else
    puts "Success creating company: #{row['Name']}"
  end
end


#######
# Now, we will import our customers.  We will be using the hash form above to look
# up the company name's for our customers.
#######
puts "Starting Customers"
company_csv_file = "./CSV_Files/customers.csv"

######
# Loop through the customer CSV file defined above
######
CSV.foreach(company_csv_file, headers: true) do |row|

  data = {
    first_name: row["FirstName"],
    last_name: row["LastName"],
    company: company_hash[row["CompanyId"]]
  }

  # look for our custom fields and add them to the data hash if found
  custom_fields = {}

  row.to_h.each do |key, value|
    if key.include? "custom_"
      custom_fields[key.gsub("custom_","").to_sym] = value unless value == ""
    end
  end

  data[:custom_fields] = custom_fields unless custom_fields == {}


  # look for any email_ columns and add them to the data hash
  emails_array = []

  row.to_h.each do |key, value|
    if key.include? "email_"
      type = key.gsub("email_","")
      emails_array << {"type": type, "value": value} unless value == ""
    end
  end

  data[:emails] = emails_array

  # look for any phone_ columns and add them to the data hash
  phones_array = []

  row.to_h.each do |key, value|
    if key.include? "phone_"
      type = key.gsub("phone_","")
      phones_array << {"type": type, "value": value} unless value == ""
    end
  end

  data[:phones] = phones_array

  begin
    new_customer = DeskApi.customers.create(data)
  rescue DeskApi::Error => e
    binding.pry
    puts "Error creating customer: #{row['Name']} - #{e.errors}"
    customer_error_log.error "Error creating customer: #{row['Name']} - #{e.errors}"
  else
    puts "Success creating customer: #{emails_array[0][:value]}"
  end
end
