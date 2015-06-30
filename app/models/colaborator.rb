class Colaborator < ActiveRecord::Base
  belongs_to :contestant, inverse_of: :colaborators
  belongs_to :project, inverse_of: :colaborators
end
