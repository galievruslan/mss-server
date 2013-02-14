class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :parent_id
      t.string :external_key
      t.boolean :validity, :default => true

      t.timestamps
    end
    add_index :categories, :external_key, :unique => true
  end
end
