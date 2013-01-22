class CreateProductUnitOfMeasures < ActiveRecord::Migration
  def change
    create_table :product_unit_of_measures do |t|
      t.integer :product_id
      t.integer :unit_of_measure_id
      t.integer :count_in_base_unit

      t.timestamps
    end
  end
end
