class AddUrlHostToLinks < ActiveRecord::Migration
  def change
    add_column :links, :url_host, :string
  end
end
