class CreateRoutePointPhotos < ActiveRecord::Migration
  def change
    create_table :route_point_photos do |t|
      t.integer :route_point_id
      t.string :photo
      t.text :comment

      t.timestamps
    end
  end
end
