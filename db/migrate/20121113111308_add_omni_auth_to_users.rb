class AddOmniAuthToUsers < ActiveRecord::Migration
  def change
    
    add_column :users, :uid, :string
    add_column :users, :oauth_token, :string
    add_column :users, :oauth_expires_at, :datetime
    add_column :users, :username, :string
  end
end
