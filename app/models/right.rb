class Right < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true
  belongs_to :role
  validates :role, presence: true

  rails_admin do
    list do
      field :user
      field :role
    end
  end
end
