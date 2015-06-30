class Right < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true
  belongs_to :role
  validates :role, presence: true
end
