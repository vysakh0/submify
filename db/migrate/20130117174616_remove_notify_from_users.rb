class RemoveNotifyFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :notify
  end
end
