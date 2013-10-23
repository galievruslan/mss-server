class AuditDocument < ActiveRecord::Base
  attr_accessible :comment, :date, :manager_id, :percentage_shelves, :shipping_address_id, :manager, :shipping_address
  belongs_to :manager
  belongs_to :shipping_address
  validates :date, :manager, :shipping_address, :presence => true
  validates :percentage_shelves, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100}
  validates :shipping_address_id, :uniqueness => { :scope => [:date, :manager_id], :message => I18n.t(:one_audit_document_per_date) }
  
  def self.available_for_user(user)
    if user.role? :manager and user.manager_id   
      self.where(manager_id: user.manager_id)
    else
      self
    end  
  end  
end
