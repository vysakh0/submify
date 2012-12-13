class CreateCommentDownvotes < ActiveRecord::Migration
  def change
    create_table :comment_downvotes do |t|
      t.integer :comment_id, :limit => 8
      t.integer :user_id, :limit => 8

      t.timestamps
    end
    add_index :comment_downvotes, [:user_id, :comment_id], unique: true
  end
end
