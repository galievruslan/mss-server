class AddListPageSizeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :list_page_size, :integer
  end
end
