class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  has_many :rights, dependent: :destroy
  has_many :roles, through: :rights
  has_many :contestants, dependent: :destroy
  has_many :teachers, dependent: :destroy
  has_one :alumnus, dependent: :destroy, inverse_of: :user
  has_many :talk_users, dependent: :destroy
  has_many :talks, through: :talk_users
  has_many :projects, through: :contestants, inverse_of: :users

  # discourse_id needs to be unique
  validates :discourse_id, uniqueness: true, :allow_nil => true
  validates :first_name, presence: true
  validates :last_name , presence: true

  after_commit :update_access_token!, on: :create
  after_create :set_default_role

  def update_projects_discourse
    projects.each do |p|
      p.update_discourse
    end
    talks.each do |t|
      t.update_discourse
    end
  end

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

  def get_current_teacher
    self.teachers.find_by(:edition => Edition.get_current)
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
      field :newsletter
    end
    list do
      field :email
      field :first_name
      field :last_name
      field :job
      field :roles
      field :confirmed?, :boolean do
        label "Confirmed"
      end
    end
    show do
      field :first_name
      field :last_name
      field :email
      field :job
      field :current_sign_in_at
      field :confirmed?, :boolean do
        label "Confirmed"
      end
      field :roles
      field :contestants
      field :alumnus
      field :talks
      field :projects
      field :newsletter
    end
  end
end
