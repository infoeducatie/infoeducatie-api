class News < ActiveRecord::Base
  validates :title, presence: true
  validates :body, presence: true, length: { in: 20..1000 }

  rails_admin do
    list do
      field :title
      field :pinned
      field :body
      field :created_at
    end
  end
end
