# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

['registered', 'contestant', 'alumni', 'speaker', "teacher", "admin"].each do |role|
  Role.find_or_create_by({name: role})
end
