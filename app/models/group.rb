class Group < ActiveRecord::Base
  attr_accessible :name, :user_ids
  validates :name, :presence => true
  has_and_belongs_to_many :users
end
