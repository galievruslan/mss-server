class AddDefaultWarehouseIdToManagers < ActiveRecord::Migration
  def change
    add_column :managers, :default_warehouse_id, :integer
  end
end
