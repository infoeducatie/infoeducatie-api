class Contestant < ActiveRecord::Base
  belongs_to :edition
  belongs_to :user

  enum sex: [:male, :female, :undisclosed]

  validates :address, presence: true
  validates :city, presence: true
  validates :county, presence: true
  validates :country, presence: true
  validates :zip_code, presence: true

  validates :sex, presence: true

  validates :cnp, presence: true
  validates :id_card_type, presence: true
  validates :id_card_number, presence: true

  validates :phone_number, presence: true
  validates :date_of_birth, presence: true

  validates :school_name, presence: true
  validates :grade, presence: true
  validates :school_county, presence: true
  validates :school_city, presence: true
  validates :school_country, presence: true

  validates :mentoring_teacher_first_name, presence: true
  validates :mentoring_teacher_last_name, presence: true

  validates :accompanying_teacher_first_name, presence: true
  validates :accompanying_teacher_last_name, presence: true

  def sex_enum
    [:male, :female, :undisclosed]
  end

  def first_name
    user.first_name
  end

  def last_name
    user.last_name
  end

  rails_admin do
    list do
      field :first_name
      field :last_name
      field :school_name
    end
  end
end
