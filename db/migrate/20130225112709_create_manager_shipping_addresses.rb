class CreateManagerShippingAddresses < ActiveRecord::Migration
  def change
    create_table :manager_shipping_addresses do |t|
      t.integer :manager_id
      t.integer :shipping_address_id

      t.timestamps
    end
  end
end
