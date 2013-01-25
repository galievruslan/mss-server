class CreateWarehouses < ActiveRecord::Migration
  def change
    create_table :warehouses do |t|
      t.string :name
      t.string :address
      t.string :external_key
      t.boolean :validity, :default => true
      t.timestamps
    end
    add_index :warehouses, :external_key, :unique => true
  end
end
