class PriceList < ActiveRecord::Base
  attr_accessible :external_key, :name, :validity, :product_price_ids, :order_ids
  has_many :product_prices, :dependent => :destroy
  has_many :orders, :dependent => :destroy
  validates :name, :external_key, :presence => true
  validates :name, :external_key, :uniqueness => { :case_sensitive => false }
end
