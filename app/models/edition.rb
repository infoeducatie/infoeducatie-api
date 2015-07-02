class Edition < ActiveRecord::Base
  has_many :contestants, dependent: :destroy

  validates :name, presence: true
  validates :year, presence: true
  validates :motto, presence: true
  validates :camp_start_date, date: true
  validates :camp_end_date, date: true
  validates :registration_start_date, presence: true, date: true
  validates :registration_end_date, presence: true, date: true
  validates :travel_data_deadline, date: true
  validates_uniqueness_of :current, if: :current

  def current=(value)
    if value and Edition.get_current
      x = Edition.get_current
      x.current = false
      x.save!
    end

    write_attribute(:current, value)
  end

  def self.get_current
    where(current: true, published: true).first
  end

  rails_admin do
    list do
      field :year
      field :name
      field :published
      field :current
    end
    edit do
      configure :contestants do
        hide
      end
    end
  end
end
