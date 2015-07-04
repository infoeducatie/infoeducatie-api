class Talk < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true

  belongs_to :edition
  validates :edition, presence: true

  validates :title, presence: true
  validates :description, presence: true

  rails_admin do
    list do
      field :title
      field :description
    end
  end
end
