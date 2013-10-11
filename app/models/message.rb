class Message < ActiveRecord::Base
  attr_accessible :body, :subject, :user_id, :user_ids
  validates :body, :subject, :user_id, :presence => true
  belongs_to :sender, :foreign_key => 'user_id', :class_name => 'User'
  has_many :users, :through => :user_messages
  has_many :user_messages, :dependent => :destroy
  
  def delivered(user)
    UserMessage.find_by_user_id_and_message_id(user.id, self.id).delivered
  end
  
  def read(user)
    UserMessage.find_by_user_id_and_message_id(user.id, self.id).update_attributes(delivered: true)
  end
end
