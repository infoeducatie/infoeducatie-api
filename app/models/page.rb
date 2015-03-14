class Page < ActiveRecord::Base
  belongs_to :edition

  validates :name, :body, :edition, presence: true
  validates :name, length: { minimum: 6, maximum: 80 }
end
