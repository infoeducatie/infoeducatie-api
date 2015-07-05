require 'digest/md5'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  has_many :rights, dependent: :destroy
  has_many :roles, through: :rights
  has_many :contestants, dependent: :destroy
  has_many :talks, dependent: :destroy, inverse_of: :user
  has_many :alumni, dependent: :destroy, inverse_of: :user

  # discourse_id needs to be unique
  validates :discourse_id, uniqueness: true, :allow_nil => true
  validates :first_name, presence: true
  validates :last_name , presence: true

  after_commit :update_access_token!, on: :create
  after_create :set_default_role

  validates :email, presence: true, uniqueness: true

  def email_md5
    Digest::MD5.hexdigest(self.email)
  end

  def admin?
    self.roles.include?(Role.find_by(name: "admin"))
  end

  def contestant?
    self.roles.include?(Role.find_by(name: "contestant"))
  end

  def get_current_contestant
    self.contestants.find_by(:edition => Edition.get_current)
  end

  def update_access_token!
    self.update_column(:access_token, "#{self.id}:#{Devise.friendly_token}")
  end

  def set_default_role
    self.roles << Role.find_by(name: "registered")
  end

  def name
    self.first_name + " " + self.last_name
  end

  def increment_registration_step_number!
    self.update_column(:registration_step_number,
                       self.registration_step_number + 1)
  end

  rails_admin do
    edit do
      field :email
      field :first_name
      field :last_name
      field :job
      field :roles
      field :password
    end
    list do
      field :email
      field :first_name
      field :last_name
      field :job
      field :roles
    end
  end
end
