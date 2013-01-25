class PriceList < ActiveRecord::Base
  attr_accessible :external_key, :name, :validity
  has_many :price_list_lines, :dependent => :destroy
  validates :name, :external_key, :presence => true
  validates :external_key, :uniqueness => { :case_sensitive => false }
end
