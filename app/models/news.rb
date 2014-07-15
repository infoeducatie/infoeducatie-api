class News < ActiveRecord::Base
  belongs_to :edition

  validates :title, :description, presence: true
  validates :title, length: { minimum: 6, maximum: 80 }
end
