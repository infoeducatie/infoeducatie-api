class Role < ActiveRecord::Base
  validates :name, presence: true

  has_many :rights
  has_many :users, through: :rights

  rails_admin do
    edit do
      configure :rights do
        hide
      end
      configure :users do
        hide
      end
    end
    list do
      field :name
    end
  end
end
