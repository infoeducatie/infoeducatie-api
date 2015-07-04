class Talk < ActiveRecord::Base
  belongs_to :user, inverse_of: :talks
  validates :user, presence: true

  belongs_to :edition, inverse_of: :talks
  validates :edition, presence: true

  validates :title, presence: true
  validates :description, presence: true

  validates :date, date: { allow_blank: true }

  def author
    user.name
  end

  rails_admin do
    list do
      field :title
      field :author
      field :location
      field :date
      field :edition
    end
  end
end
