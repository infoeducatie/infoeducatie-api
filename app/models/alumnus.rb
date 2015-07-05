class Alumnus < ActiveRecord::Base
  belongs_to :user, inverse_of: :alumni
  validates :user, presence: true

  has_many :attendances, inverse_of: :alumnus, dependent: :destroy
  has_many :editions, through: :attendances, inverse_of: :alumni

  validates :editions, presence: true
  validates :description, presence: true

  rails_admin do
    list do
      field :user
      field :editions
    end
  end
end
