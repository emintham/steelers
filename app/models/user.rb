class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :user_id, :name, :affiliation, :specialisation,
     :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  
  validates :user_id,
     :uniqueness => true,
     :presence => { :on => :create },
     :exclusion => { :in => %w( admin superuser administrator root ),
        :message => "Nice try..." }

  validates :email,
     :uniqueness => { :allow_blank => true },
     :format => { :with => /@/, :on => :create, :allow_blank => true }

end
