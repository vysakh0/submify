class AddScoreToLinkUsers < ActiveRecord::Migration
  def change
    add_column :link_users, :score, :integer, limit: 8
    add_index :link_users, :score 
  end
end
