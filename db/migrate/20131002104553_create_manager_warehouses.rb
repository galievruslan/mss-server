class CreateManagerWarehouses < ActiveRecord::Migration
  def change
    create_table :manager_warehouses do |t|
      t.integer :manager_id
      t.integer :warehouse_id
      t.boolean :validity, :default => true
      t.timestamps
    end
  end
end
