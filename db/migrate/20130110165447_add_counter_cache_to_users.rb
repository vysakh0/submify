class AddCounterCacheToUsers < ActiveRecord::Migration
  def change
    add_column :users, :comments_count, :integer, default: 0
    add_column :users, :link_users_count, :integer, default: 0
  end
end
