class AddMmlToProduct < ActiveRecord::Migration
  def change
    add_column :products, :mml, :boolean, :default => false
  end
end
