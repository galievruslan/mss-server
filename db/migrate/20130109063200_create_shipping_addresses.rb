class CreateShippingAddresses < ActiveRecord::Migration
  def change
    create_table :shipping_addresses do |t|
      t.integer :customer_id
      t.string :name
      t.string :address
      t.string :external_key
      t.boolean :validity, :default => true
      t.timestamps
    end
    add_index :shipping_addresses, :external_key, :unique => true
  end
end
