class AddValidityToTemplateRoutePoints < ActiveRecord::Migration
  def change
    add_column :template_route_points, :validity, :boolean, :default => true
  end
end
