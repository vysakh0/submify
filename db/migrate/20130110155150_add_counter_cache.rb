class AddCounterCache < ActiveRecord::Migration
  def change
    add_column :link_users, :votes_count, :integer, default: 0
    add_column :links, :comments_count, :integer, default: 0
    add_column :comments, :votes_count, :integer, default: 0
    add_column :comments, :comments_count, :integer, default: 0
  end
end
