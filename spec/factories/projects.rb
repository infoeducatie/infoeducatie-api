FactoryGirl.define do
  factory :project do
    title "MyString"
    description "MyText"
    technical_description "MyText"
    system_requirements "MyText"
    source_url "MyString"
    homepage "MyString"
    approved false
    final_score 1.5
    extra_score 1.5
    notes "MyText"
  end
end
