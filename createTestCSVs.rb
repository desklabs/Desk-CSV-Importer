puts "Initializing"

require 'rubygems'
require 'bundler/setup'
require 'dotenv'
require 'csv'
Bundler.require(:default)


if !File.exists?("./CSV_Files")
  Dir.mkdir 'CSV_Files'
end


rand_limit = 100000000

id_pool = []

cli = HighLine.new

5000.times do |i|
  id_pool << Random.rand(rand_limit)
end
id_pool = id_pool.uniq
#binding.pry

puts "Creating Company CSV"
company_ids = []
CSV.open("CSV_Files/companies.csv", "wb") do |csv|
  csv << ["id","name","domains"]
  10.times do |i|
    id = id_pool.pop
    company_ids << id
    domains = []

    num_domains = Random.rand(2) + 1
    num_domains.times do |i|
      domains << [Faker::Internet.domain_name]
    end

    csv << [id, Faker::Company.name, domains.join(",")]
  end
end

puts "Creating Customer CSV"
customer_ids = []
CSV.open("CSV_Files/customers.csv", "wb") do |csv|
  csv << ["id","first_name","last_name","title","email_home", "email_work", "email_other","phone_home","phone_work","company_id"]
  500.times do |i|
    row =[]
    id = id_pool.pop
    customer_ids << id

    row << id

    f_name = Faker::Name.first_name

    row << f_name

    l_name = Faker::Name.last_name
    row << l_name
    if Faker::Boolean.boolean
      row << Faker::Name.prefix
    else
      row << ""
    end

    num_emails = Random.rand(5) + 1
    emails = []
    num_emails.times do |i|
      emails << Faker::Internet.user_name("#{f_name} #{l_name}", %w(. _ -)) + Faker::Number.number(3) + "@" + Faker::Internet.domain_name
    end
    emails = emails.uniq
    row << emails[0]
    if !emails[1].nil?
      row << emails[1]
    else
      row << ""
    end

    if !emails[2].nil?
      row << emails[2]
    else
      row << ""
    end

    num_phones = Random.rand(5) + 1
    phones = []
    num_phones.times do |i|
      phones << Faker::PhoneNumber.phone_number
    end
    phones = phones.uniq
    row << phones[0]
    if !phones[1].nil?
      row << phones[1]
    else
      row << ""
    end

    if Faker::Boolean.boolean(0.7)
      row << ""
    else
      row << company_ids.sample
    end
    csv << row
  end
end
