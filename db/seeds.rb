# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

['registered', 'contestant', 'alumni', 'speaker', "teacher", "admin"].each do |role|
  Role.find_or_create_by({name: role})
end

['web', 'utilitar', 'educational', 'multimedia', 'roboti'].each do |category|
  Category.find_or_create_by({name: category})
end

Edition.find_or_create_by({
  year: '2015',
  name: '2015',
  camp_start_date: DateTime.new(2015, 8, 2),
  camp_end_date: DateTime.new(2015, 8, 8),
  motto: 'Persevereaza, mergi mai departe',
  registration_start_date: DateTime.new(2015, 7, 5),
  registration_end_date: DateTime.new(2015, 7, 28),
  travel_data_deadline: DateTime.new(2015, 7, 28),
  published: true,
  current: true,
  projects_forum_category: "Lucrari 2015 Nationala",
  talks_forum_category: "Prezentari 2015 Nationala"
})

unless User.find_by({email: 'admin@infoeducatie.ro'})
  user = User.create({
    email: 'admin@infoeducatie.ro',
    password: 'secretpassword',
    password_confirmation: 'secretpassword',
    first_name: 'Super',
    last_name: 'Admin'
  })
  user.confirm
  user.roles << Role.find_by(name: "admin")
end

# WARNING! This seed can be used in development mode. Never uncomment this in productition.

#Contestant.find_or_create_by(school_name: "Scoala Vietii \"Bibi zis Ciuma\"") do |contestant|
#  contestant.address = "str. Muzeul Verde, nr. 11, bl. H4, sc. W, ap. 8"
#  contestant.city = "Barlad"
#  contestant.county = "Vaslui"
#  contestant.country = "Romania"
#  contestant.zip_code = "731050"
#
#  contestant.sex = 0
#
#  contestant.cnp = "123123"
#  contestant.id_card_type = "VS"
#  contestant.id_card_number = "123123"
#
#  contestant.phone_number = "123123123"
#
#  contestant.grade = "IX"
#  contestant.school_county = "Vaslui"
#  contestant.school_city = "Negresti"
#  contestant.school_country = "Romania"
#
#  contestant.date_of_birth = "30/05/1990"
#  contestant.mentoring_teacher_first_name = "Cersei"
#  contestant.mentoring_teacher_last_name = "Lannister"
#
#  contestant.official = false
#  contestant.present_in_camp = true
#  contestant.paying_camp_accommodation = true
#end
