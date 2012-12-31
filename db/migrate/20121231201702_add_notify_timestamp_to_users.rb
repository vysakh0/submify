class AddNotifyTimestampToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notify, :timestamp
    add_index :notifications, :updated_at
  end
end
