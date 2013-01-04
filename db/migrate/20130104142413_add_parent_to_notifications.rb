class AddParentToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :parent_id, :integer, :limit => 8
    add_column :notifications, :parent_type, :string

    add_index :notifications, :parent_id
    add_index :notifications, [:parent_id, :parent_type]
  end
end
