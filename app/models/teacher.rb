class Teacher < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true

  belongs_to :edition
  validates :edition, presence: true
  validates :edition_id, uniqueness: { scope: [:user_id] }

  validates :sex, presence: true
  validates :sex, numericality: { only_integer: true,
                                  greater_than_or_equal_to: 1,
                                  less_than_or_equal_to: 3}

  validates :phone_number, presence: true
  validates :school_name, presence: true
  validates :school_county, presence: true
  validates :school_city, presence: true
  validates :school_country, presence: true

  def sex_enum
    [ [ :male, 1 ], [ :female, 2 ], [ :undisclosed, 3 ] ]
  end

  def name
    user.name if user
  end

  rails_admin do
    list do
      field :name
      field :school_name
      field :school_county
      field :edition
    end
  end
end
