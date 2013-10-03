class CreateRemainders < ActiveRecord::Migration
  def change
    create_table :remainders do |t|
      t.integer :warehouse_id
      t.integer :product_id
      t.integer :unit_of_measure_id
      t.integer :quantity

      t.timestamps
    end
  end
end
