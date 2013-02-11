class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments, id: false do |t|
      t.column :id, :primary_key 
      t.text :body
      t.integer :user_id, limit: 8
      t.integer :commentable_id, :limit => 8
      t.string :commentable_type
      t.integer :score, limit: 8
      t.timestamps
    end
    execute "SELECT setval('comments_id_seq', 1000)"
    add_index :comments, [:commentable_id, :commentable_type]
    add_index :comments, :user_id
    add_index :comments, :commentable_id
    add_index :comments, :score
  end
end
