class CreateBlogPosts < ActiveRecord::Migration[8.1]
  def change
    create_table :blog_posts do |t|
      t.string :slug, null: false
      t.string :title, null: false
      t.string :title_en
      t.text :excerpt, null: false
      t.text :excerpt_en
      t.text :body, null: false
      t.text :body_en
      t.string :author_name, null: false
      t.string :category
      t.string :category_en
      t.datetime :published_at, null: false
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :blog_posts, :slug, unique: true
    add_index :blog_posts, [:active, :published_at]
  end
end
