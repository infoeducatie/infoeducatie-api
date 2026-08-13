class Alumnus < ActiveRecord::Base
  belongs_to :user, inverse_of: :alumnus
  validates :user, presence: true, uniqueness: true

  has_many :attendances, inverse_of: :alumnus, dependent: :destroy
  has_many :editions, through: :attendances, inverse_of: :alumni

  validates :editions, presence: true
  validates :description, presence: true

  def name
    user.name if user
  end

  def localized_description(locale)
    if locale.to_s.downcase.start_with?("en")
      description_en.presence || description
    else
      description
    end
  end

  rails_admin do
    list do
      field :user do
        searchable [:first_name, :last_name, :email]
      end
      field :editions
    end
    edit do
      field :user
      field :editions
      field :description do
        label "Description (Romanian)"
      end
      field :description_en do
        label "Description (English)"
        help "Optional. Romanian content is used when the English translation is blank."
      end
    end
  end
end
