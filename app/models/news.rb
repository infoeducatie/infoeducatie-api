class News < ActiveRecord::Base
  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 20 }
  validates :short, presence: true

  belongs_to :edition
  validates :edition, presence: true

  before_validation do
    self.short = ActionController::Base.helpers.strip_tags(self.body)[0..125]
  end

  rails_admin do
    list do
      field :title
      field :short
      field :pinned
      field :created_at
      field :edition
    end
    edit do
      field :title
      field :pinned
      field :edition
      field :body, :ck_editor
    end
  end
end
