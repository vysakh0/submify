class AddNotifyTimestampToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notify, :timestamp, default: Time.now
  end
end
