class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.integer :unit_of_measure_id
      t.float :price
      t.string :external_key
      t.boolean :validity, :default => true
      t.timestamps
    end
  end
end
