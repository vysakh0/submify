class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links, id: false do |t|
      t.column :id, :primary_key 
      t.string :url_link
      t.string :url_heading
      t.timestamps
    end

    execute "SELECT setval('links_id_seq', 1000)"
    add_index :links, :url_link, unique: true
  end
end
