# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

['registered', 'contestant', 'alumni', 'speaker', "teacher", "admin"].each do |role|
  Role.find_or_create_by({name: role})
end

['web', 'utilitar', 'educational', 'multimedia', 'roboti'].each do |category|
  Category.find_or_create_by({name: category})
end

current_edition = Edition.find_or_create_by(year: '2015') do |edition|
  edition.name = '2015'
  edition.camp_start_date = DateTime.new(2015, 8, 2)
  edition.camp_end_date = DateTime.new(2015, 8, 8)
  edition.motto = 'Persevereaza, mergi mai departe'
  edition.registration_start_date = DateTime.new(2015, 7, 5)
  edition.registration_end_date = DateTime.new(2015, 7, 28)
  edition.travel_data_deadline = DateTime.new(2015, 7, 28)
  edition.published = true
  edition.current = true
  edition.projects_forum_category = "Lucrari 2015 Nationala"
  edition.talks_forum_category = "Prezentari 2015 Nationala"
end

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

current_user = User.find_by(email: 'admin@infoeducatie.ro')

# WARNING! This seed can be used in development mode. Never uncomment this in productition.

# current_contestant = Contestant.find_or_create_by(school_name: "Scoala Vietii \"Bibi zis Ciuma\"") do |contestant|
#  contestant.address = "str. Muzeul Verde, nr. 11, bl. H4, sc. W, ap. 8"
#  contestant.city = "Barlad"
#  contestant.county = "Vaslui"
#  contestant.country = "Romania"
#  contestant.zip_code = "731050"

#  contestant.sex = 1

#  contestant.cnp = "123123"
#  contestant.id_card_type = "VS"
#  contestant.id_card_number = "123123"

#  contestant.phone_number = "123123123"

#  contestant.grade = "IX"
#  contestant.school_county = "Vaslui"
#  contestant.school_city = "Negresti"
#  contestant.school_country = "Romania"

#  contestant.date_of_birth = "30/05/1990"
#  contestant.mentoring_teacher_first_name = "Cersei"
#  contestant.mentoring_teacher_last_name = "Lannister"

#  contestant.official = false
#  contestant.present_in_camp = true
#  contestant.paying_camp_accommodation = true

#  contestant.edition = current_edition
#  contestant.user = current_user
# end

# current_project = Project.find_or_create_by(title: "Catalog Scolar by R0b3rT") do  |project|
#   project.category = Category.find_by(name: 'web')
#   project.contestants = [current_contestant]
#   project.title = "Catalog Scolar by R0b3rT"
#   project.description = "smen"
#   project.technical_description = "rails cu react"
#   project.system_requirements = "pentium 3"
#   project.score = 100
#   project.extra_score = 69
#   project.open_source = true
#   project.source_url = "https://github.com/infoeducatie"
#   project.homepage = "https://github.com/infoeducatie"
#   project.finished = true
#   project.status = 1
# end
  current_talk = Talk.find_or_create_by(title: "pehaspe e misto") do |talk|
    talk.title = "pehaspe e misto"
    talk.description = "valoare"
    talk.edition = current_edition
    talk.users = [current_user]
