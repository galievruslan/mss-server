class CreateShippingAddresses < ActiveRecord::Migration
  def change
    create_table :shipping_addresses do |t|
      t.integer :customer_id
      t.string :name
      t.string :address
      t.timestamps
    end
  end
end
