class Page < ActiveRecord::Base
  belongs_to :edition

  validates :title, :body, presence: true
  validates :title, length: { minimum: 6, maximum: 80 }
end
