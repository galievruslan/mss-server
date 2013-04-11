class AddRoutePointIdToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :route_point_id, :integer
  end
end
