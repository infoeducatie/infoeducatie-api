attributes :id,
           :address,
           :city,
           :county,
           :country,
           :zip_code,
           :cnp,
           :id_card_type,
           :id_card_number,
           :phone_number,
           :school_name,
           :grade,
           :school_county,
           :school_city,
           :school_country,
           :date_of_birth,
           :mentoring_teacher_first_name,
           :mentoring_teacher_last_name,
           :official,
           :present_in_camp,
           :paying_camp_accommodation

child :user => :user do
  attributes :id, :first_name, :last_name
end

child :edition => :edition do
  attributes :id, :year, :name
end
