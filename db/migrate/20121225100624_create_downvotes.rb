class CreateDownvotes < ActiveRecord::Migration
  def change
    create_table :downvotes do |t|
      t.integer :user_id, limit: 8
      t.integer :votable_id, limit: 8
      t.string :votable_type
      t.timestamps
    end
    add_index :downvotes, [:votable_id, :votable_type]
    add_index :downvotes, [:user_id, :votable_id, :votable_type], unique: true
  end
end
