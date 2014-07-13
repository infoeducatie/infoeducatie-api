class Edition < ActiveRecord::Base
  has_many :news
  has_many :pages
end
