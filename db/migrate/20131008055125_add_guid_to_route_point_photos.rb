class AddGuidToRoutePointPhotos < ActiveRecord::Migration
  def change
    add_column :route_point_photos, :guid, :string
    add_index :route_point_photos, :guid
  end
end
