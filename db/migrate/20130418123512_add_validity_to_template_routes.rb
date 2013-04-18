class AddValidityToTemplateRoutes < ActiveRecord::Migration
  def change
    add_column :template_routes, :validity, :boolean, :default => true
  end
end
