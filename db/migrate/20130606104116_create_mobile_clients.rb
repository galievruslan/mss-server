class CreateMobileClients < ActiveRecord::Migration
  def change
    create_table :mobile_clients do |t|
      t.string :client_type
      t.string :version
      t.string :file

      t.timestamps
    end
  end
end
