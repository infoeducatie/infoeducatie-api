class Role < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_many :rights, dependent: :destroy
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
