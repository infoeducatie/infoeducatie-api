class Edition < ActiveRecord::Base
  scope :current, -> { where(current: true, published: true) }

  has_many :contestants
end
