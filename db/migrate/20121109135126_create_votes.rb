class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :user_id, :limit => 8
      t.integer :votable_id, :limit => 8
      t.string :votable_type

      t.timestamps
    end
    add_index :votes, [:votable_id, :votable_type]
    add_index :votes, [:user_id, :votable_id, :votable_type], unique: true
    add_index :votes, :user_id
    add_index :votes, :votable_id
  end
end
