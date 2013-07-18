class User < ActiveRecord::Base
  # ---------- Authentication/Authorization ---------------------------
  rolify

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :user_id, :name, :affiliation, :specialisation,
     :email, :password, :password_confirmation, :remember_me
  
  # ------------------ Associations -----------------------------------
  # restrict deletion of users if user has outstanding jobs
  has_many :jobs, :order => :id, :dependent => :restrict
  accepts_nested_attributes_for :jobs, 
     :allow_destroy => true

  # can delete user if user has logs but no jobs
  has_many :logs, :order => :id
  accepts_nested_attributes_for :logs, 
     :allow_destroy => true

  has_many :confs, :order => :id
  accepts_nested_attributes_for :confs,
     :allow_destroy => true

  # ------------------- Validations -----------------------------------
  validates :user_id,
     :uniqueness => true,
     :presence => { :on => :create }

  # -------------------- Initialization -------------------------------
  ## Create directory for user after creation of user
  after_create :create_dir
  
  protected
  def create_dir
     user_dir = Rails.root.join('u', user_id).to_s
     permission = 0700
     if File.directory?(user_dir)
        logger.info "<DEV INFO> #{user_id} already has directory!"
     else
        Dir.mkdir(user_dir,permission)
        logger.info "<DEV INFO> <RAILS_ROOT>/u/#{user_id}/ created!"
     end
  end
end
