class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :name
      t.boolean :validity, :default => true
      t.timestamps
    end
  end
end
