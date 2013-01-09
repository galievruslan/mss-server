class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.date :date
      t.integer :manager_id

      t.timestamps
    end
  end
end
