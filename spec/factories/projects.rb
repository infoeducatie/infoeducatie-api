FactoryGirl.define do
  factory :project do
    title "MyString"
    description "MyText"
    technical_description "MyText"
    system_requirements "MyText"
    source_url "MyString"
    homepage "MyString"
    status 0
    extra_score 1.5
    finished false
    category { Category.find_by(name: "web") }
    contestants { build_list(:contestant, 1) }
    open_source true

    before(:create) do |project, evaluator|
      project.colaborators[0].project = project
    end
  end

  factory :project_without_contestant_category, class: Project do
    skip_create
    title "MyString"
    description "MyText"
    technical_description "MyText"
    system_requirements "MyText"
    source_url "MyString"
    homepage "MyString"
    status 0
    extra_score 1.5
    finished false
    open_source true
  end
end
