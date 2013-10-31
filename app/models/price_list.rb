class PriceList < ValidableModel
  attr_accessible :external_key, :name, :validity, :product_price_ids, :order_ids
  has_many :product_prices, :dependent => :destroy
  has_many :orders, :dependent => :destroy
  has_many :products, :through => :product_prices
  validates :name, :external_key, :presence => true
  validates :name, :external_key, :uniqueness => { :case_sensitive => false }
  
  def set_invalid
    self.product_prices.each do |product_price|
      product_price.set_invalid
    end
    super
  end
end
