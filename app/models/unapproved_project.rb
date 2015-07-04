class UnapprovedProject < Project
  default_scope { where(finished: true).where(approved: false) }

  rails_admin do
    parent FinishedProject

    list do
      field :title, :string
      field :authors, :string
      field :description, :string
      field :category_name, :string
      field :county, :string
      field :screenshots
      field :approved, :boolean
      field :finished, :boolean
    end

    create do
      field :title, :string
      field :description, :string
      field :technical_description, :string
      field :system_requirements, :string
      field :source_url, :string
      field :homepage, :string

      field :approved, :boolean
      field :finished, :boolean

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

    edit do
      field :title, :string
      field :description, :string
      field :technical_description, :string
      field :system_requirements, :string
      field :source_url, :string
      field :homepage, :string

      field :approved, :boolean
      field :finished, :boolean

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
