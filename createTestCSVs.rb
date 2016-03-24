require 'rubygems'
require 'bundler/setup'
require 'dotenv'
require 'csv'
Bundler.require(:default)

#binding.pry

if !File.exists?("./CSV_Files")
  Dir.mkdir 'CSV_Files'
end

todays_date_string = Date.today.year.to_s + "_" + Date.today.month.to_s + "_" + Date.today.day.to_s

rand_limit = 100000000

puts "Creating Company CSV"
company_ids = []
CSV.open("CSV_Files/#{todays_date_string}_company.csv", "wb") do |csv|
  csv << ["Id","Name"]
  50.times do |i|
    id = Random.rand(rand_limit)
    company_ids << id
    csv << [id, Faker::Company.name]
  end
end

puts "Creating Customer CSV"
customer_ids = []
CSV.open("CSV_Files/#{todays_date_string}_customer.csv", "wb") do |csv|
  csv << ["Id","FirstName","LastName","CompanyId"]
  50.times do |i|
    id = Random.rand(rand_limit)
    customer_ids << id
    #in_comp = Random.rand(3)
    if Faker::Boolean.boolean(0.7)
      csv << [id, Faker::Name.first_name,Faker::Name.last_name]
    else
      csv << [id, Faker::Name.first_name,Faker::Name.last_name, company_ids.sample]
    end
  end
end

puts "Creating Group CSV"
group_ids = []
CSV.open("CSV_Files/#{todays_date_string}_group.csv", "wb") do |csv|
  csv << ["Id","Name"]
  8.times do |i|
    id = Random.rand(rand_limit)
    group_ids << id
    csv << [id, Faker::Commerce.department(1)]
  end
end

puts "Creating User CSV"
user_ids = []
CSV.open("CSV_Files/#{todays_date_string}_user.csv", "wb") do |csv|
  csv << ["Id","Name","Email"]
  20.times do |i|
    id = Random.rand(rand_limit)
    user_ids << id
    csv << [id, Faker::Name.name,Faker::Internet.safe_email]
  end
end

puts "Creating Case CSV"
statuses = ["new","open","pending","resolved"]
cases = []

CSV.open("CSV_Files/#{todays_date_string}_case.csv", "wb") do |csv|
  csv << ["Id","CustomerId","Subject","Status","CreatedAt","UpdatedAt","UserId","GroupId"]
  50.times do |i|
    id = Random.rand(rand_limit)
    #case_ids << id

    status = statuses.sample
    created_at = Faker::Time.backward(14, :evening).to_datetime.new_offset(0).iso8601
    cases << {:id => id, :created_at => created_at}
    row = [id, customer_ids.sample, Faker::Lorem.sentence(3), status, created_at]
    if status == "new"
      row << ""
      row << ""
      row << ""
    else
      row << Faker::Time.between(created_at, DateTime.now).to_datetime.new_offset(0).iso8601
      row << user_ids.sample
    end
    csv << row
  end
end

puts "Creating Notes CSV"
note_ids = []
CSV.open("CSV_Files/#{todays_date_string}_notes.csv", "wb") do |csv|
  csv << ["Id","CaseId","UserId","CreatedAt","Body"]
  200.times do |i|

    case_ = cases.sample
    case_created_at = case_[:created_at]
    case_id = case_[:id]

    id = Random.rand(rand_limit)
    csv << [id, case_id,user_ids.sample, Faker::Time.between(case_created_at, DateTime.now).to_datetime.new_offset(0).iso8601, Faker::Hipster.paragraph(2)]

  end
end


binding.pry
