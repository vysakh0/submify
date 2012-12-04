class AddTopicToLinkUsers < ActiveRecord::Migration
  def change
    add_column :link_users, :topic_id, :integer
    add_index :link_users, :topic_id
    add_index :link_users, [:link_id, :user_id, :topic_id], unique: true

  end
end
