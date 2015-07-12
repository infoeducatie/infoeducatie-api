class TalkUser < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true
  belongs_to :talk
  validates :talk, presence: true
end
