class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  has_many :rights
  has_many :roles, through: :rights
  has_many :contestants

  # discourse_id needs to be unique
  validates :discourse_id, uniqueness: true, :allow_nil => true
  validates :first_name, presence: true
  validates :last_name , presence: true

  after_create :update_access_token!
  after_create :set_default_role

  validates :email, presence: true, uniqueness: true

  def admin?
    self.roles.include?(Role.find_by(name: "admin"))
  end

  def contestant?
    self.roles.include?(Role.find_by(name: "contestant"))
  end

  def update_access_token!
    self.access_token = "#{self.id}:#{Devise.friendly_token}"
    save
  end

  def set_default_role
    self.roles << Role.find_by(name: "registered")
  end

  rails_admin do
    edit do
      field :email
      field :first_name
      field :last_name
      field :roles
      field :password
    end
    list do
      field :email
      field :first_name
      field :last_name
      field :roles
    end
  end
end
