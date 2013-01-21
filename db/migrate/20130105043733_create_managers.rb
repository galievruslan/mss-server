class CreateManagers < ActiveRecord::Migration
  def change
    create_table :managers do |t|
      t.string :name
      t.string :external_key
      t.boolean :validity, :default => true
      t.timestamps
    end
    
    add_index :managers, :external_key, :unique => true
  end
end
