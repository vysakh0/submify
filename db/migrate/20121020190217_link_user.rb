class LinkUser < ActiveRecord::Migration

  def change

    create_table :links_users, id: false do |t|

      t.integer :link_id, null: false
      t.integer :user_id, null: false
    end

    add_index :links_users, [:link_id, :user_id]
  end

end
