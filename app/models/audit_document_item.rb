class AuditDocumentItem < ActiveRecord::Base
  attr_accessible :audit_document_id, :quantity, :face, :facing, :golden_shelf, :price, :product_id, :product, :audit_document
  validates :product, :quantity, :presence => true
  validates :quantity, :numericality => {:greater_than => 0, :only_integer => true}
  validates :price, :numericality => {:greater_than_or_equal_to => 0 }, allow_nil: true
  validates :face, :numericality => {:greater_than_or_equal_to => 0, :only_integer => true}, allow_nil: true
  validates :facing, :numericality => {:greater_than_or_equal_to => 0, :only_integer => true}, allow_nil: true
  validates :product_id, :uniqueness => { :scope => :audit_document_id, :message => I18n.t(:one_product_per_audit_document) }
  belongs_to :audit_document
  belongs_to :product 
end
