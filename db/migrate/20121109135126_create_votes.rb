class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :user_id
      t.integer :votable_id, :limit => 8
      t.string :votable_type

      t.timestamps
    end
    add_index :votes, [:user_id, :votable_id], unique: true
  end
end
