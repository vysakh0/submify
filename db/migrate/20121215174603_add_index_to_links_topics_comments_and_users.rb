class AddIndexToLinksTopicsCommentsAndUsers < ActiveRecord::Migration
  def change
    add_index :users, :id
    add_index :links, :id
    add_index :comments, :id
    add_index :topics, :id
  end
end
