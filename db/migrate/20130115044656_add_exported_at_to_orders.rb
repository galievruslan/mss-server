class AddExportedAtToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :exported_at, :datetime
  end
end
