class FinishedProject < Project
  default_scope { where(finished: true) }

  rails_admin do
    label "Projects"

    list do
      field :title
      field :authors
      field :category_name
      field :county
      field :status do
        column_width 90
      end
      field :open_source do
        label "Open"
        column_width 60
      end
      field :has_source_url, :boolean do
        label "Repository"
        column_width 90
      end
    end

    edit do
      field :title
      field :description
      field :technical_description
      field :system_requirements
      field :open_source
      field :source_url
      field :homepage
      field :closed_source_reason
      field :github_username

      field :category do
        nested_form false
      end

      field :contestants do
        nested_form false
      end
    end
  end

end
