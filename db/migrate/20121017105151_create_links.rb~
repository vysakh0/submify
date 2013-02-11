class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :url_link
      t.string :url_heading
      t.timestamps
    end
    add_index :links, [:created_at]
  end
end
