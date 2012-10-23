class CreateLinkUsers < ActiveRecord::Migration
  def change
    create_table :link_users do |t|
      t.integer :link_id
      t.integer :user_id

      t.timestamps
    end
    add_index :link_users, :link_id
    add_index :link_users, :user_id
    add_index :link_users, [:link_id, :user_id], unique: true

  end
end
