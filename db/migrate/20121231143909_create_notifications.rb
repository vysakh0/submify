class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id, :limit => 8
      t.integer :notifiable_id, :limit => 8
      t.string :notifiable_type
      t.timestamps
    end
    add_index :notifications, :user_id
    add_index :notifications, :notifiable_id
    add_index :notifications, [:notifiable_id, :notifiable_type]
  end
end
