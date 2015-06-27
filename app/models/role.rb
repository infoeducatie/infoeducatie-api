class Role < ActiveRecord::Base
  has_many :rights
  has_many :users, through: :rights
end
