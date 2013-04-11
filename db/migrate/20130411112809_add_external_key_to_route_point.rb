class AddExternalKeyToRoutePoint < ActiveRecord::Migration
  def change
    add_column :route_points, :external_key, :string
  end
end
