class Category < ActiveRecord::Base
  has_many :projects

  validates :name, uniqueness: true, presence: true

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
