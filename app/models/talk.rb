class Talk < ActiveRecord::Base
  validates :title, :description, :scheduled_at, :duration, :location, presence: true
  validates :title, length: { minimum: 6, maximum: 80 }
  validates :location, length: { minimum: 5, maximum: 80 }
end
