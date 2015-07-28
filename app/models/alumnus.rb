class Alumnus < ActiveRecord::Base
  belongs_to :user, inverse_of: :alumnus
  validates :user, presence: true, uniqueness: true

  has_many :attendances, inverse_of: :alumnus, dependent: :destroy
  has_many :editions, through: :attendances, inverse_of: :alumni

  validates :editions, presence: true
  validates :description, presence: true

  after_create :update_mailchimp
  def update_mailchimp
    user.update_mailchimp
  end

  def name
    user.name if user
  end

  rails_admin do
    list do
      field :user
      field :editions
    end
  end
end
