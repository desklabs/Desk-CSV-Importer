require 'rubygems'
require 'bundler/setup'
require 'dotenv'
require 'csv'
require 'logger'
Bundler.require(:default)
Dotenv.load

error_log = Logger.new('error.log')
success_log = Logger.new('success.log')

class DeskApi::Request::Retry
  class << self
    def errors
      @exceptions ||= [
        Errno::ETIMEDOUT,
        'Timeout::Error',
        Faraday::Error::TimeoutError,
        DeskApi::Error::TooManyRequests,
        DeskApi::Error::InternalServerError,
        DeskApi::Error::GatewayTimeout,
        DeskApi::Error::BadGateway
      ]
    end
  end
end

def process_row(error_log, success_log, row)
  data = {
    first_name: row["first_name"].strip!,
    last_name: row["last_name"].strip!,
    external_id: row["portfolio_id"],
    custom_fields: {
      portfolio_id: row["portfolio_id"]
    }
  }

  if row["home_phone"]
    data["phone_numbers"] =
    [
      {
        type: "home",
        value: row["home_phone"]
      }
    ]
  end

  if row["home_email"]
    data["emails"] =
    [
      {
        type: "home",
        value: row["home_email"]
      }
    ]
  end

  if row["home_address"]
    data["addresses"] =
    [
      {
        type: "home",
        value: row["home_address"]
      }
    ]
  end
  #puts data
  begin
    new_customer = DeskApi.customers.create(data)
  rescue DeskApi::Error => e


    if e.errors == {"emails" => [{"value" => ["taken"]}]}
      sleep(1)
      existing_customer = DeskApi.customers.search(email: row["home_email"]).entries.first
      if existing_customer
        begin
          data["addresses_update_action"] = "replace"
          #puts "updating"
          #binding.pry
          existing_customer.update(data)
        rescue DeskApi::Error::Conflict
          sleep(1)
          existing_customer = DeskApi.customers.search(email: row["home_email"]).entries.first
          retry
        rescue DeskApi::Error => e2
          error_log.error data
          error_log.error e2
        else
          success_log.info row["home_email"] + " updated"
        end
      else
        error_log.error row["home_email"] + " failed"
      end
    else
      error_log.error data
      error_log.error e.errors
    end
  else
    success_log.info row["home_email"] + " created"
  end
  #print "."
end

DeskApi.configure do |config|
  # basic authentication
  config.username = ENV['DESK_USERNAME']
  config.password = ENV['DESK_PASSWORD']
  config.endpoint = ENV['DESK_ENDPOINT']
end

CSVFiles = Dir["./CSV_Files/*"]

rows = []

CSV.foreach(CSVFiles.grep(/pcsb/)[0], headers: true) do |row|
  rows << row
end

#binding.pry
# rows.each do |row|
#   process_row(error_log, row)
# end

Parallel.each(rows, in_processes: 4, progress: "Working", isolation: true) do |row|
  process_row(error_log, success_log, row)
end
