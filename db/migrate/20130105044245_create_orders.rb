class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.datetime :date
      t.datetime :shipping_date
      t.text :comment
      t.integer :shipping_address_id
      t.integer :manager_id
      t.integer :warehouse_id
      t.integer :price_list_id
      t.timestamps
    end
  end
end
