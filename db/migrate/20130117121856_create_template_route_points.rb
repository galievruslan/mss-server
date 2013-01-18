class CreateTemplateRoutePoints < ActiveRecord::Migration
  def change
    create_table :template_route_points do |t|
      t.integer :template_route_id
      t.integer :shipping_address_id

      t.timestamps
    end
  end
end
