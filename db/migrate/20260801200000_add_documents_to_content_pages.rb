class AddDocumentsToContentPages < ActiveRecord::Migration[8.1]
  def change
    add_column :content_pages, :document, :string
    add_column :content_pages, :document_en, :string
  end
end
