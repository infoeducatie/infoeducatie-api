class Project < ActiveRecord::Base
  belongs_to :category
  has_many :colaborators
  has_many :contestants, through: :colaborators, inverse_of: :projects

  accepts_nested_attributes_for :category
  accepts_nested_attributes_for :colaborators,
    :reject_if => :all_blank,
    :allow_destroy => true
  accepts_nested_attributes_for :contestants

  validates :category, presence: true
  validates :contestants, presence: true

  validates :title, presence: true
  validates :description, presence: true
  validates :technical_description, presence: true
  validates :system_requirements, presence: true
  validates :source_url, presence: true

  validates :homepage, presence: true, if: Proc.new { |project|
    !self.category.nil? && self.category.name == "web"
  }

end
