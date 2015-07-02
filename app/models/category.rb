class Category < ActiveRecord::Base
  has_many :projects, inverse_of: :category

  validates :name, uniqueness: true, :allow_nil => true

  accepts_nested_attributes_for :projects, :allow_destroy => true
end
