FactoryGirl.define do
  factory :teacher do
    sex 1
    phone_number "123123123"
    school_name "Scoala Vietii"
    school_county "Vaslui"
    school_city "Negresti"
    school_country "Romania"

    association :edition
    association :user
  end
end
