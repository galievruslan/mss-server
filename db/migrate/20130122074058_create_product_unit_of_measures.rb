class CreateProductUnitOfMeasures < ActiveRecord::Migration
  def change
    create_table :product_unit_of_measures do |t|
      t.integer :product_id
      t.integer :unit_of_measure_id
      t.float :count_in_base_unit
      t.boolean :base, :default => false      

      t.timestamps
    end
  end
end
