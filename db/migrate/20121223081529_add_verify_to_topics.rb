class AddVerifyToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :verify, :boolean, default: false
  end
end
