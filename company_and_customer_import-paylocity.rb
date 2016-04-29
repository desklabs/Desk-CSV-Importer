require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'logger'
Bundler.require(:default)



######
# Pull settings from the .env file.
######
Dotenv.load

def process_company_row(company_error_log, company_hash, row)
  company_hash[row["id"]] = row["name"]
  return
  custom_fields = {}
  # Build our data hash to for the new company
  data = {
    name: row["name"],
    external_id: row["id"],
    domains: row["domains"]
  }
  # look for our custom fields and add them to the data hash if found
  row.to_h.each do |key, value|
    if key.include? "custom_"
      custom_fields[key.gsub("custom_","").to_sym] = value
    end
  end

  data[:custom_fields] = custom_fields
  #create a company for the row
  begin
    new_company = DeskApi.companies.create(data)
    # if it fails, log it in the error log
  rescue DeskApi::Error => e

    company_error_log.error "Error creating company: #{row['name']}"
    # if e.errors and e.errors == {"name"=>["taken"]}

    #   existing_company = DeskApi.companies.search("#{row['id']}").entries.first
    #   if existing_company.name == row['name']
    #     data["addresses_update_action"] = "replace"

    #     begin
    #       existing_company.update(data)
    #     rescue DeskApi::Error => e
    #       company_error_log.error "Error updating Company: #{row['name']}"
    #     else
    #       company_error_log.info "Company: #{row['name']} updated"
    #     end

    #   end
    # end



  else
    company_error_log.info "Company: #{row['name']} created"
  end
end

def process_customer_row(company_hash, customer_error_log, row)
  data = {
    first_name: row["first_name"],
    last_name: row["last_name"],
    title: row["title"],
    company: company_hash[row["company_id"]],

  }
  # look for our custom fields and add them to the data hash if found
  custom_fields = {}

  row.to_h.each do |key, value|
    if key.include? "custom_"
      custom_fields[key.gsub("custom_","").to_sym] = value
    end
  end

  data[:custom_fields] = custom_fields

  emails_array = []
  emails_array << {"type": "work", "value": row["email"]} if row["email"]
  emails_array << {"type": "home", "value": row["home_email"]} if row["home_email"]

  data[:emails] = emails_array

  phones_array = []
  phones_array << {"type": "work", "value": row["phone"]} if row["phone"]
  phones_array << {"type": "mobile", "value": row["mobile_phone"]} if row["mobile_phone"]

  data[:phone_numbers] = phones_array

  # begin
  #   new_customer = DeskApi.customers.create(data)

  # rescue DeskApi::Error => e
  #   customer_error_log.error "Error creating customer: #{row['email']}"
  #   if e.errors and e.errors == {"emails"=>[{"value"=>["taken"]}]}
  data["addresses_update_action"] = "replace"
  data["emails_update_action"] = "replace"
  data["phone_numbers_update_action"] = "replace"
  existing_customer = DeskApi.customers.search(email: row["email"]).entries.first

  begin
    existing_customer.update(data)

  rescue Net::OpenTimeout => e
    binding.pry
  rescue DeskApi::Error => e
    customer_error_log.error "Error updating customer: #{row['email']} - #{e} - #{e.errors}"
    #binding.pry
  else
    customer_error_log.info "Customer: #{row['email']} updated"
  end
  #   end
  # else
  #   customer_error_log.info "Success creating customer: #{row['email']}"
  # end
end


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
company_csv_file = "./CSV_Files/16_04_28_companies.csv"

######
# Since our cusrtomer CSV file only contains our Company ID from our old system,
# we need to store each company's name and ID into an array for later use in customers
######
company_hash = {}


######
# Loop through the company CSV file defined above
######


comp_rows = []

CSV.foreach(company_csv_file, headers: true, :encoding => 'ISO-8859-1') do |row|
  comp_rows << row
end

Parallel.each(comp_rows, in_threads: 40, progress: "Working") do |row|
  process_company_row(company_error_log, company_hash, row)
end

# CSV.foreach(company_csv_file, headers: true) do |row|
#   process_company_row(company_error_log, company_hash, row)
# end


#######
# Now, we will import our customers.  We will be using the hash form above to look
# up the company name's for our customers.
#######
puts "Starting Customers"
customer_csv_file = "./CSV_Files/10_04_28_customers.csv"

cust_rows = []

CSV.foreach(customer_csv_file, headers: true, :encoding => 'ISO-8859-1') do |row|
  #puts row
  begin
    cust_rows << row
  rescue
    binding.pry
  end
end

######
# Loop through the customer CSV file defined above
######
# CSV.foreach(customer_csv_file, headers: true) do |row|
#   process_customer_row(company_hash, customer_error_log, row)
# end

Parallel.each(cust_rows, in_threads: 40, progress: "Working", isolation: true) do |row|
  begin
    process_customer_row(company_hash, customer_error_log, row)
  rescue
    sleep 1
    retry
  end

end
