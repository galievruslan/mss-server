class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :registerable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :username, :password, :password_confirmation, :remember_me, :manager_id, :role_ids, :list_page_size, :language, :banned, :phone, :client_type, :client_version
  # attr_accessible :title, :body
  has_and_belongs_to_many :roles
  validates :username, :presence => true
  validates :username, :uniqueness => { :case_sensitive => false }
  validates :manager_id, :uniqueness => {:message => I18n.t(:is_tied_to_the_user_manager)}, :allow_nil => true 
    
  def role?(role)
    return self.roles.find_by_name(role).try(:name) == role.to_s
  end 
  
  # Remove email presence validation
  def email_required?
    false
  end
end
