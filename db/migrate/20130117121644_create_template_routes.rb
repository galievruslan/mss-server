class CreateTemplateRoutes < ActiveRecord::Migration
  def change
    create_table :template_routes do |t|
      t.integer :manager_id
      t.integer :day_of_week

      t.timestamps
    end
  end
end
