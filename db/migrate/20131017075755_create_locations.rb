class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :user_id
      t.datetime :timestamp
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
