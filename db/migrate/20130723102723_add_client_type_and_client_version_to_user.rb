class AddClientTypeAndClientVersionToUser < ActiveRecord::Migration
  def change
    add_column :users, :client_type, :string
    add_column :users, :client_version, :string
  end
end
