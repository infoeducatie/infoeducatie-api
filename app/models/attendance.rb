class Attendance < ActiveRecord::Base
  belongs_to :alumnus, inverse_of: :attendances
  belongs_to :edition, inverse_of: :attendances
end
