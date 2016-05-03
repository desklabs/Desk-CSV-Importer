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
  csv << ["Id","Name"]
  50.times do |i|
    id = id_pool.pop
    company_ids << id
    csv << [id, Faker::Company.name]
  end
end

puts "Creating Customer CSV"
customer_ids = []
CSV.open("CSV_Files/customers.csv", "wb") do |csv|
  csv << ["Id","FirstName","LastName","Title","email_home", "email_work", "email_other","phone_home","phone_work","CompanyId"]
  50.times do |i|
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

abort

puts "Creating Group CSV"
group_ids = []
CSV.open("CSV_Files/#{todays_date_string}_group.csv", "wb") do |csv|
  csv << ["Id","Name"]
  8.times do |i|
    id = id_pool.pop
    group_ids << id
    csv << [id, Faker::Commerce.department(1)]
  end
end

puts "Creating User CSV"
user_ids = []
CSV.open("CSV_Files/#{todays_date_string}_user.csv", "wb") do |csv|
  csv << ["Id","Name","Email"]
  20.times do |i|
    id = id_pool.pop
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
    id = id_pool.pop

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
  500.times do |i|

    case_ = cases.sample
    case_created_at = case_[:created_at]
    case_id = case_[:id]

    id = id_pool.pop
    csv << [id, case_id,user_ids.sample, Faker::Time.between(case_created_at, DateTime.now).to_datetime.new_offset(0).iso8601, Faker::Hipster.paragraph(2)]

  end
end

puts "Creating Replies CSV"
directions = ["in","out"]
reply_ids = []
CSV.open("CSV_Files/#{todays_date_string}_replies.csv", "wb") do |csv|

  csv << ["Id","CaseId","UserId","CreatedAt","Body","Direction"]
  500.times do |i|
    case_ = cases.sample
    case_created_at = case_[:created_at]
    case_id = case_[:id]

    id = id_pool.pop
    csv << [id, case_id,user_ids.sample, Faker::Time.between(case_created_at, DateTime.now).to_datetime.new_offset(0).iso8601, Faker::Hipster.paragraph(2), directions.sample]

  end

end

#binding.pry
