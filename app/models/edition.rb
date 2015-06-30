class Edition < ActiveRecord::Base
  default_scope { where(published: true) }

  has_many :contestants
end
