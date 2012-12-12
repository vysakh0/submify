class AddAvatarToLinks < ActiveRecord::Migration
  def change
     add_attachment :links, :avatar
  end
end
