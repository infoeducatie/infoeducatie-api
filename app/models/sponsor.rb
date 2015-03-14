class Sponsor < ActiveRecord::Base

  validates :name, :logo, presence: true
  validates :name, length: { minimum: 3, maximum: 50 }
  validates :logo, length: { minimum: 3, maximum: 200 }
end
