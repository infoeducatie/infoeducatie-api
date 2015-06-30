FactoryGirl.define do
  factory :contestant do
    address "str. Muzeul Verde, nr. 11, bl. H4, sc. W, ap. 8"
    city "Barlad"
    county "Vaslui"
    country "Romania"
    zip_code "731050"

    sex 1

    cnp "123123"
    id_card_type "VS"
    id_card_number "123123"

    phone_number "123123123"

    school_name "Scoala Vietii"
    grade "IX"
    school_county "Vaslui"
    school_city "Negresti"
    school_country "Romania"

    date_of_birth "30/05/1990"
    mentoring_teacher_first_name "Cersei"
    mentoring_teacher_last_name "Lannister"

    accompanying_teacher_first_name "Cercel"
    accompanying_teacher_last_name "Dinescu"

    official false
    present_in_camp true
    paying_camp_accommodation true

    before(:create) { |contestant|
      contestant.edition = Edition.first || FactoryGirl.create(:edition)
      contestant.user = User.first || FactoryGirl.create(:user)
    }
  end
end
