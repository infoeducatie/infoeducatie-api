class Colaborator < ActiveRecord::Base
  belongs_to :contestant, inverse_of: :colaborators
  validates :contestant, presence: true

  belongs_to :project, inverse_of: :colaborators
  validates :project, presence: true

  rails_admin do
    list do
      field :contestant
      field :project
    end
  end
end
