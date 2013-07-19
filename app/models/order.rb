class Order < ActiveRecord::Base
  attr_accessible :shipping_address_id, :date, :shipping_date, :manager_id, :route_point_id, :exported_at, :manager, :shipping_address, :warehouse_id, :warehouse, :comment, :price_list_id, :price_list, :order_item_ids, :order_items_attributes, :guid, :complete, :amount
  belongs_to :shipping_address
  belongs_to :manager
  belongs_to :warehouse
  belongs_to :price_list
  belongs_to :route_point
  has_many :order_items, :dependent => :destroy
  validates :date, :shipping_date, :manager, :shipping_address, :warehouse, :price_list, :presence => true
  accepts_nested_attributes_for :order_items, :allow_destroy => true
  validate :validate_unique_order_items
  validate :validate_dates
  validates :guid, :uniqueness => { :case_sensitive => false }, :allow_nil => true
  
  after_save :set_amount
  
  def set_amount
    amount = 0    
    self.order_items.each do |order_item|
      if order_item.amount.nil?
        order_item_amount = 0
      else
        order_item_amount = order_item.amount
      end
      amount = amount + order_item_amount
    end
    update_column(:amount, amount)
  end
  
  def validate_dates
    if !shipping_date.blank? and !date.blank?
      errors.add(:shipping_date , I18n.t(:not_be_less_date)) if shipping_date < date
    end
  end
    
  def validate_unique_order_items
    validate_uniqueness_of_in_memory(
      order_items, [:product_id], I18n.t(:dublicate_order_item))
  end
  
  def self.total_on(start_date, end_date)
    self.where(:date => start_date.beginning_of_day..end_date.end_of_day).sum(:amount).round(2)
  end
  
    def self.count_on(start_date, end_date)
    self.where(:date => start_date.beginning_of_day..end_date.end_of_day).count
  end
  
  def self.available_for_user(user)
    if user.role? :manager and user.manager_id   
      self.where(manager_id: user.manager_id)
    else
      self
    end  
  end
  
  def self.belongs_to_route_point(route_point_id)    
    self.where(route_point_id: route_point_id)
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