class Message < ActiveRecord::Base
  attr_accessible :body, :subject, :sender
  validates :body, :subject, :sender, :presence => true
  belongs_to :user, foreign_key: "sender"
end
