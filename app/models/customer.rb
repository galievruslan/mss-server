class Customer < ValidableModel
  attr_accessible :name, :external_key, :validity, :shipping_address_ids, :address, :debt
  has_many :shipping_addresses, :dependent => :destroy
  validates :name, :external_key, :address, :presence => true
  validates :external_key, :uniqueness => { :case_sensitive => false }
  validates :debt, :numericality => {:greater_than_or_equal_to => 0 }
  
  def set_invalid
    self.shipping_addresses.each do |shipping_address|
      shipping_address.set_invalid
    end
    super
  end
end