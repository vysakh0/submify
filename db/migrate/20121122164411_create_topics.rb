class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :name
      t.text :description

      t.string :slug

      t.timestamps
    end
    add_index :topics, :slug, unique: true
  end
end
