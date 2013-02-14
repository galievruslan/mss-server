class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :external_key
      t.boolean :validity, :default => true
      t.timestamps
    end
    add_index :products, :external_key, :unique => true
  end
end
