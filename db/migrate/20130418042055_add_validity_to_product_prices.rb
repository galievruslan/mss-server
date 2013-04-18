class AddValidityToProductPrices < ActiveRecord::Migration
  def change
    add_column :product_prices, :validity, :boolean, :default => true
  end
end
