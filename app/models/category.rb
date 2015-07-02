class Category < ActiveRecord::Base
  has_many :projects, inverse_of: :category, dependent: :destroy

  validates :name, uniqueness: true, presence: true

  accepts_nested_attributes_for :projects

  rails_admin do
    list do
      field :name
    end
    edit do
      configure :projects do
        hide
      end
    end
  end
end
