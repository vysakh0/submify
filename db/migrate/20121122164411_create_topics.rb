class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics, id: false do |t|
 t.column :id, :primary_key 
      t.string :name
      t.text :description

      t.string :slug

      t.timestamps
    end
execute "SELECT setval('topics_id_seq', 1000)"

    add_index :topics, :slug, unique: true
 add_index :topics, :name, unique: true
  end
end
