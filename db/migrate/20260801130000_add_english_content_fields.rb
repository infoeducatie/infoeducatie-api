class AddEnglishContentFields < ActiveRecord::Migration[8.1]
  def change
    add_column :alumni, :description_en, :text

    add_column :news, :title_en, :string
    add_column :news, :body_en, :text

    add_column :talks, :title_en, :string
    add_column :talks, :description_en, :text

    add_column :users, :job_en, :string
  end
end
