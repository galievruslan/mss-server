class Message < ActiveRecord::Base
  attr_accessible :body, :subject
  validates :body, :subject, :presence => true
end
