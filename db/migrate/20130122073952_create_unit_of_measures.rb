class CreateUnitOfMeasures < ActiveRecord::Migration
  def change
    create_table :unit_of_measures do |t|
      t.string :name
      t.string :external_key
      t.boolean :validity, :default => true
      t.timestamps
    end
    add_index :unit_of_measures, :external_key, :unique => true
  end
end
