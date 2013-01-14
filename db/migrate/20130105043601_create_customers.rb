class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :external_key
      t.timestamps
    end
    
    add_index :customers, :external_key, :unique => true
  end
end
