class Contestant < ActiveRecord::Base
  belongs_to :edition
  validates :edition, presence: true
  validates :edition_id, uniqueness: { scope: [:user_id] }

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

  before_destroy :delete_orphan_projects, prepend: true

  after_create :update_mailchimp
  def update_mailchimp
    user.update_mailchimp
  end

  after_save :update_projects_discourse
  def update_projects_discourse
    projects.approved.each do |p|
      p.update_discourse
    end
  end

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
      field :user do
        searchable [:first_name, :last_name, :email]
      end
      field :school_name
      field :county
      field :edition
    end
    edit do
      configure :projects do
        hide
      end
    end
    show do
      configure :projects do
        show
      end
    end
  end

  private
    def delete_orphan_projects
      projects.each do |project|
        if project.contestants.count == 1
          project.destroy
        end
      end
    end

end
