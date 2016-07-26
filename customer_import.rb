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
# Now, we will import our customers.  We will be using the hash form above to look
# up the company name's for our customers.
#######
puts "Starting Customers"
customer_csv_file = "./CSV_Files/customers.csv"

######
# Loop through the customer CSV file defined above
######
x=2
CSV.foreach(customer_csv_file, headers: true, :encoding => 'ISO-8859-1') do |row|

  data = {
    first_name: row["first_name"],
    last_name: row["last_name"],
    external_id: row["id"],
    title: row["title"]
  }

  # look for our custom fields and add them to the data hash if found
  custom_fields = {}

  row.to_h.each do |key, value|
    if key =~ /^custom_/
      custom_fields[key.gsub("custom_","").to_sym] = value unless value.nil? or value == ""
    end
  end

  data[:custom_fields] = custom_fields unless custom_fields == {}

  # look for any address_ columns and add them to the data hash
  address_array = []

  row.to_h.each do |key, value|
    if key =~ /^address_/
      type = key.gsub("address_","")
      address_array << {"type": type, "value": value} unless value.nil? or value == ""
    end
  end

  data[:addresses] = address_array unless address_array == []

  # look for any email_ columns and add them to the data hash
  emails_array = []

  row.to_h.each do |key, value|
    if key =~ /^email_/
      type = key.gsub("email_","")
      emails_array << {"type": type, "value": value} unless value.nil? or value == ""
    end
  end

  data[:emails] = emails_array unless emails_array == []

  # look for any phone_ columns and add them to the data hash
  phones_array = []

  row.to_h.each do |key, value|
    if key =~ /^phone_/
      type = key.gsub("phone_","")
      phones_array << {"type": type, "value": value} unless value.nil? or value == ""
    end
  end

  data[:phone_numbers] = phones_array unless phones_array == []

  begin
    new_customer = DeskApi.customers.create(data)
  rescue DeskApi::Error => e
    puts "Error creating customer: CSV Row: #{x}, Customer ID: #{row['id']} - #{e.errors}"
    customer_error_log.error "Error creating customer - CSV Row: #{x}, Customer ID: #{row['id']} - #{e.errors}"
  else
    puts "Success creating customer: CSV Row: #{x}, Customer ID: #{row['id']}"
  end

  x += 1

end
