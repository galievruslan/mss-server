class CreatePriceListLines < ActiveRecord::Migration
  def change
    create_table :price_list_lines do |t|
      t.integer :price_list_id
      t.integer :product_id
      t.decimal :price, :precision => 7, :scale => 2
      
      t.timestamps
    end
  end
end
