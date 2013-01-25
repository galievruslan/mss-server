class PriceListLine < ActiveRecord::Base
  attr_accessible :price, :price_list_id, :product_id, :price_list, :product
  belongs_to :price_list
  belongs_to :product
  validates :price, :price, :product_id ,:presence => true
  validates :price, :numericality => {:greater_than_or_equal_to => 0 }
  validates :price_list_id, :uniqueness => { :scope => :product_id,
    :message => "should happen once per product" }
end
