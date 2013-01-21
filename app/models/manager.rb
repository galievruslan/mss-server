class Manager < ActiveRecord::Base
  attr_accessible :name, :external_key, :validity
  has_many :orders, :dependent => :destroy
  has_many :routes, :dependent => :destroy
  has_many :template_routes, :dependent => :destroy
  validates :name, :external_key, :presence => true
  validates :external_key, :uniqueness => { :case_sensitive => false }
end
