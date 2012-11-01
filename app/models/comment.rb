class Comment < ActiveRecord::Base
  attr_accessible :body

  belongs_to :link  
  belongs_to :user
  validates :link_id, presence: true 
  validates :user_id, presence: true
 
end
