class CreateProductPrices < ActiveRecord::Migration
  def change
    create_table :product_prices do |t|
      t.integer :product_id
      t.integer :price_list_id
      t.decimal :price, :precision => 7, :scale => 2

      t.timestamps
    end
  end
end
