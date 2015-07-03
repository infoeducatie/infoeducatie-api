class News < ActiveRecord::Base
  validates :title, presence: true
  validates :body, length: { in: 20..1000 }
end
