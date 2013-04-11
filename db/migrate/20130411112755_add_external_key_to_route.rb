class AddExternalKeyToRoute < ActiveRecord::Migration
  def change
    add_column :routes, :external_key, :string
  end
end
