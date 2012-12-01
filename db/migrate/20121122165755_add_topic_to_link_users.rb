class AddTopicToLinkUsers < ActiveRecord::Migration
  def change
    add_column :link_users, :topic_id, :integer
    add_index :link_users, :topic_id
  end
end
