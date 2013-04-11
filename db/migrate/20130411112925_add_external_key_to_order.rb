class AddExternalKeyToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :external_key, :string
  end
end
