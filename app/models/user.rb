class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :registerable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :username, :password, :password_confirmation, :remember_me, :manager_id, :role_ids
  # attr_accessible :title, :body
  has_and_belongs_to_many :roles
  
  def role?(role)
    return self.roles.find_by_name(role).try(:name) == role.to_s
  end 
end
