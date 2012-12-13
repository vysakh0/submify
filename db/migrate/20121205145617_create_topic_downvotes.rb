class CreateTopicDownvotes < ActiveRecord::Migration
  def change
    create_table :topic_downvotes do |t|
      t.integer :user_id, :limit => 8
      t.integer :topic_id, :limit => 8
      t.integer :link_id, :limit => 8
      t.timestamps
    end
    add_index :topic_downvotes, [:user_id, :topic_id, :link_id], unique: true
  end
end
