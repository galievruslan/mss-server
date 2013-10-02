class AddDebtToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :debt, :decimal, :precision => 13, :scale => 2
  end
end
