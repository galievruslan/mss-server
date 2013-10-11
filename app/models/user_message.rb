class UserMessage < ActiveRecord::Base
  attr_accessible :delivered, :message_id, :user_id, :messsage, :user
  belongs_to :user
  belongs_to :message
  validates :message, :user, :presence => true
  validates :message_id, :uniqueness => { :scope => :user_id,
    :message => I18n.t(:one_message_per_user) }
end
