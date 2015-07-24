class Talk < ActiveRecord::Base
  belongs_to :edition, inverse_of: :talks, counter_cache: true
  validates :edition, presence: true

  validates :title, presence: true
  validates :description, presence: true

  validates :date, date: { allow_blank: true }
  validates :topic_id, numericality: { only_integer: true,
                                       greater_than: 0,
                                       allow_blank: true}

  has_many :talk_users, dependent: :destroy
  has_many :users, through: :talk_users
  validates :users, presence: true

  def name
    "#{title} @ #{edition.name}" if edition
  end

  def topic_created
    !topic_id.nil? && topic_id > 0
  end

  def discourse_url
    "#{Settings.ui.community_url}/t/#{topic_id}" if topic_id
  end

  rails_admin do
    list do
      field :title
      field :location
      field :date
      field :edition
      field :users
      field :topic_created, :boolean
    end
  end
end
