class Category < ActiveRecord::Base
  attr_accessible :external_key, :name, :parent_id, :validity, :parent
  belongs_to :parent, :class_name => "Category"
  has_many :childrens,  :class_name => "Category", :foreign_key => "parent_id"
  has_many :products, :dependent => :destroy
  validates :name, :external_key, :presence => true
  validates :external_key, :uniqueness => { :case_sensitive => false }  
end
