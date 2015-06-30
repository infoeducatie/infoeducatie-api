class Project < ActiveRecord::Base
  belongs_to :category
  has_many :colaborators
  has_many :contestants, through: :colaborators
end
