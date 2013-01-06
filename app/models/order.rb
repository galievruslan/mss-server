class Order < ActiveRecord::Base
  attr_accessible :customer_id, :date, :manager_id
  has_many :customers
  has_many :managers
  belongs_to :order_item
end
