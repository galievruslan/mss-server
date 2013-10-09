class GroupsUsers < ActiveRecord::Migration
  def self.up
    create_table :groups_users, :id => false do |t|
      t.references :user, :group
    end
  end
 
  def self.down
    drop_table :groups_users
  end
end
