class UnapprovedProject < Project
  default_scope { where(finished: true).where(approved: false) }

  rails_admin do
    parent FinishedProject

    list do
      field :title
      field :authors
      field :category_name
      field :county
      field :open_source
      field :screenshots
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

      field :screenshots do
        nested_form false
      end
    end

  end

end
