require 'rubygems'
require 'bundler/setup'
require 'dotenv'
require 'csv'
Bundler.require(:default)

#binding.pry

comp_ids = []

puts "Creating Company CSV"
CSV.open("CSV_Files/YY_MM_DD_company.csv", "wb") do |csv|
  csv << ["Id","Name"]
  50.times do |i|
    id = Random.rand(100000000000)
    comp_ids << id
    csv << [id, "#{Faker::Company.name}"]
  end
end

puts comp_ids
#binding.pry

puts "Creating Customer CSV"
CSV.open("CSV_Files/YY_MM_DD_customer.csv", "wb") do |csv|

  csv << ["Id","FirstName","LastName","CompanyId"]
  50.times do |i|
    in_comp = Random.rand(3)

    if in_comp <=1
      csv << [i, "#{Faker::Name.first_name}","#{Faker::Name.last_name}"]
    else
      csv << [i, "#{Faker::Name.first_name}","#{Faker::Name.last_name}", comp_ids.sample]
    end
  end
end
