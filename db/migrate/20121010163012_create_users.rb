class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: false do |t|
      t.column :id, :primary_key
      t.string :name
      t.string :email
      t.timestamps
    end
execute "SELECT setval('users_id_seq', 1000)"

  end
end
