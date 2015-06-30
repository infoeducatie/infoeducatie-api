# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

['registered', 'contestant', 'alumni', 'speaker', "teacher", "admin"].each do |role|
  Role.find_or_create_by({name: role})
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
