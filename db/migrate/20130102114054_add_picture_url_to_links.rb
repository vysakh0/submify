class AddPictureUrlToLinks < ActiveRecord::Migration
  def change
    add_column :links, :picture, :string
  end
end
