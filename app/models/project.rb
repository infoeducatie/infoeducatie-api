class Project < ActiveRecord::Base
  belongs_to :category
  has_many :colaborators
  has_many :contestants, through: :colaborators

  accepts_nested_attributes_for :category
  accepts_nested_attributes_for :colaborators,
    :reject_if => :all_blank,
    :allow_destroy => true
  accepts_nested_attributes_for :contestants

  validates :category, presence: true
  validates :contestants, presence: true

end
