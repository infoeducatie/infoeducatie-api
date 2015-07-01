class Category < ActiveRecord::Base
  has_many :projects

  validates :name, uniqueness: true, :allow_nil => true
end
