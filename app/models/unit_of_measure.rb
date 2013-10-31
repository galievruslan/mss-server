class UnitOfMeasure < ValidableModel
  attr_accessible :name, :validity, :external_key, :product_unit_of_measure_ids, :order_item_ids
  has_many :product_unit_of_measures, :dependent => :destroy
  has_many :order_items, :dependent => :destroy
  has_many :products, :through => :product_unit_of_measures
  has_many :remainders, :dependent => :destroy
  validates :name, :external_key, :presence => true
  validates :name, :external_key, :uniqueness => { :case_sensitive => false }
  
  def set_invalid
    self.product_unit_of_measures.each do |product_unit_of_measure|
      product_unit_of_measure.set_invalid
    end
    super
  end
end
