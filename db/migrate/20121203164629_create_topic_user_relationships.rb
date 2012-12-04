class CreateTopicUserRelationships < ActiveRecord::Migration
  def change
    create_table :topic_user_relationships do |t|
      t.integer :user_id
      t.integer :topic_id

      t.timestamps
    end
    add_index :topic_user_relationships, :user_id
    add_index :topic_user_relationships, :topic_id

    add_index :topic_user_relationships, [:user_id, :topic_id], unique: true
  end
end
