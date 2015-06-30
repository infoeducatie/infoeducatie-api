class Edition < ActiveRecord::Base
  default_scope { where(published: true) }
  scope :current, -> { where(current: true, published: true) }

  has_many :contestants, dependent: :destroy
end
