class AddScoreToCommentsAndLinkUsers < ActiveRecord::Migration
  def change
    add_column :links, :score, :integer, limit: 8
    add_column :comments, :score, :integer, limit: 8
    add_index :links, :score
    add_index :comments, :score
  end
end
