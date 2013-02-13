class PriceList < ActiveRecord::Base
  attr_accessible :external_key, :name, :validity, :price_list_line_ids, :order_ids
  has_many :price_list_lines, :dependent => :destroy
  has_many :orders, :dependent => :destroy
  validates :name, :external_key, :presence => true
  validates :name, :external_key, :uniqueness => { :case_sensitive => false }
end
