class AddValidityToManagerShippingAddresses < ActiveRecord::Migration
  def change
    add_column :manager_shipping_addresses, :validity, :boolean, :default => true
  end
end
