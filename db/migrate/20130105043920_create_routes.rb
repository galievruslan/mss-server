class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.date :date

      t.timestamps
    end
  end
end
