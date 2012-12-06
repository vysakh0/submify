class CreateCommentDownvotes < ActiveRecord::Migration
  def change
    create_table :comment_downvotes do |t|
      t.integer :comment_id
      t.integer :user_id

      t.timestamps
    end
    add_index :comment_downvotes, [:user_id, :comment_id], unique: true
  end
end
