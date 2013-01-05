class CreateRoutePoints < ActiveRecord::Migration
  def change
    create_table :route_points do |t|
      t.integer :customer_id
      t.integer :status_id
      t.integer :route_id

      t.timestamps
    end
  end
end
