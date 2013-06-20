class AddAmountToOrderItem < ActiveRecord::Migration
  def change
    add_column :order_items, :amount, :float
  end
end
