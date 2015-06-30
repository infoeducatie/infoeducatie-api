class Colaborator < ActiveRecord::Base
  belongs_to :contestant
  belongs_to :project
end
