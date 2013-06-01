class AddGuidToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :guid, :string
    
    add_index :orders, :guid
  end
end
