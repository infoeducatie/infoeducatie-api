class Contestant < ActiveRecord::Base
  belongs_to :edition
  validates :edition, presence: true

  belongs_to :user
  validates :user, presence: true

  has_many :colaborators, inverse_of: :contestant, dependent: :destroy
  has_many :projects, through: :colaborators, inverse_of: :contestants

  accepts_nested_attributes_for :colaborators,
    :reject_if => :all_blank
  accepts_nested_attributes_for :projects

  validates :edition, presence: true

  validates :address, presence: true
  validates :city, presence: true
  validates :county, presence: true
  validates :country, presence: true
  validates :zip_code, presence: true

  validates :sex, presence: true
  validates :sex, numericality: { only_integer: true,
                                  greater_than_or_equal_to: 1,
                                  less_than_or_equal_to: 3}

  validates :cnp, presence: true
  validates :id_card_type, presence: true
  validates :id_card_number, presence: true

  validates :phone_number, presence: true
  validates :date_of_birth, presence: true, date: true

  validates :school_name, presence: true
  validates :grade, presence: true
  validates :school_county, presence: true
  validates :school_city, presence: true
  validates :school_country, presence: true

  validates :mentoring_teacher_first_name, presence: true
  validates :mentoring_teacher_last_name, presence: true

  def sex_enum
    [ [ :male, 1 ], [ :female, 2 ], [ :undisclosed, 3 ] ]
  end

  def first_name
    user.first_name
  end

  def last_name
    user.last_name
  end

  def name
    user.name if user
  end

  def email
    user.email
  end

  rails_admin do
    list do
      field :name
      field :school_name
      field :edition
    end
    edit do
      configure :projects do
        hide
      end
    end
  end
end
