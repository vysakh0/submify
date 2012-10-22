class AddIndexToLinksUsers < ActiveRecord::Migration
  def change
    add_index :links_users, :link_id
    add_index :links_users, :user_id
  end
end
