class CreateTopicDownvotes < ActiveRecord::Migration
  def change
    create_table :topic_downvotes do |t|
      t.integer :user_id
      t.integer :topic_id
      t.integer :link_id
      t.timestamps
    end
    add_index :topic_downvotes, [:user_id, :topic_id, :link_id], unique: true
  end
end
