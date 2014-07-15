class Edition < ActiveRecord::Base
  has_many :news
  has_many :pages

  validates :start, :end, :cardinal, presence: true
  validates :motto, length: { maximum: 100, minimum: 5 }
end
