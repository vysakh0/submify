class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.integer :link_id
      t.timestamps
    end
    add_index :comments, [:link_id, :created_at]
  end
end
