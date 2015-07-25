class Edition < ActiveRecord::Base
  has_many :contestants, dependent: :destroy
  has_many :news, dependent: :destroy
  has_many :talks, dependent: :destroy, inverse_of: :edition

  has_many :attendances, dependent: :destroy, inverse_of: :edition
  has_many :alumni, through: :attendances, inverse_of: :editions
  has_many :projects, through: :contestants

  validates :name, presence: true, uniqueness: true
  validates :year, presence: true
  validates :motto, presence: true
  validates :camp_start_date, date: { allow_blank: true }
  validates :camp_end_date, date: { allow_blank: true }
  validates :registration_start_date, presence: true, date: true
  validates :registration_end_date, presence: true, date: true
  validates :travel_data_deadline, date: { allow_blank: true }
  validates :projects_forum_category, presence: true
  validates :talks_forum_category, presence: true

  def count
    year - 1994 + 1
  end

  def projects_count
    Project.where(status: Project::STATUS_APPROVED)
           .joins(:contestants)
           .where(contestants: { edition: id })
           .group_by(&:id)
           .count
  end

  def counties_count
    Contestant.where(edition: id)
              .joins(:projects)
              .where("projects.status": Project::STATUS_APPROVED)
              .group_by(&:county).count
  end

  def contestants_count
    Contestant.where(edition: id)
              .joins(:projects)
              .where("projects.status": Project::STATUS_APPROVED)
              .distinct.count
  end

  before_save do
    if current
      edition = Edition.get_current
      if not edition.nil? and edition != self
        edition.current = false
        edition.save!
      end
    end
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
      field :year
      field :name
      field :motto
      field :projects_forum_category
      field :talks_forum_category
      field :camp_start_date
      field :camp_end_date
      field :registration_start_date
      field :registration_end_date
      field :travel_data_deadline
      field :published
      field :current
      field :show_results
    end
  end
end
