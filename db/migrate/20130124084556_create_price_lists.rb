class CreatePriceLists < ActiveRecord::Migration
  def change
    create_table :price_lists do |t|
      t.string :name
      t.string :external_key
      t.boolean :validity, :default => true
      t.timestamps
    end
    add_index :price_lists, :external_key, :unique => true
  end
end
