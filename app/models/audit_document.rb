class AuditDocument < ActiveRecord::Base
  attr_accessible :comment, :date, :manager_id, :percentage_shelves, :shipping_address_id, :manager, :shipping_address, :audit_document_item_ids, :audit_document_items_attributes
  belongs_to :manager
  belongs_to :shipping_address
  has_many :audit_document_items, :dependent => :destroy
  validates :date, :manager, :shipping_address, :presence => true
  validates :percentage_shelves, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100}
  validates :shipping_address_id, :uniqueness => { :scope => [:date, :manager_id], :message => I18n.t(:one_audit_document_per_date) }
  accepts_nested_attributes_for :audit_document_items, :allow_destroy => true
  def self.available_for_user(user)
    if user.role? :manager and user.manager_id   
      self.where(manager_id: user.manager_id)
    else
      self
    end  
  end
  
  def validate_unique_audit_document_items
    validate_uniqueness_of_in_memory(
      audit_document_items, [:product_id], I18n.t(:dublicate_audit_document_item))
  end  
end
module ActiveRecord
  class Base
    # Validate that the the objects in +collection+ are unique
    # when compared against all their non-blank +attrs+. If not
    # add +message+ to the base errors.
    def validate_uniqueness_of_in_memory(collection, attrs, message)
      hashes = collection.inject({}) do |hash, record|
        key = attrs.map {|a| record.send(a).to_s }.join
        if key.blank? || record.marked_for_destruction?
          key = record.object_id
        end
        hash[key] = record unless hash[key]
        hash
      end
      if collection.length > hashes.length
        self.errors.add(:base, message)
      end
    end
  end
end