class AddMoreCounterToUsers < ActiveRecord::Migration
  def change
    add_column :users, :relationships_count, :integer, default: 0
    add_column :users, :notifications_count, :integer, default: 0
  end
end
