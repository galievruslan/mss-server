class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.date :date
      t.integer :shipping_address_id
      t.integer :manager_id

      t.timestamps
    end
  end
end
