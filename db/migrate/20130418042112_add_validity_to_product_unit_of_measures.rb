class AddValidityToProductUnitOfMeasures < ActiveRecord::Migration
  def change
    add_column :product_unit_of_measures, :validity, :boolean, :default => true
  end
end
