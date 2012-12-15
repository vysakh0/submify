class AddIndexToForeignKeyIds < ActiveRecord::Migration
  def change
    add_index :votes, :user_id
    add_index :topic_downvotes, :user_id
    add_index :topic_downvotes, :topic_id
    add_index :topic_downvotes, :link_id
    add_index :comment_downvotes, :user_id
    add_index :comment_downvotes, :comment_id
    add_index :flags, :user_id
  end
end
