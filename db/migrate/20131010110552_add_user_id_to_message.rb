class AddSenderToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :user_id, :integer
  end
end
